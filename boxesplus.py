#!/usr/bin/env python3
"""
BoxesPlus - Improved converter with proper table and diagram handling
"""

import re
import os
import sys
import subprocess
from pathlib import Path
import textwrap

BOX_CHARS = {"┌", "┐", "└", "┘", "│", "─", "├", "┤", "┬", "┴", "┼"}


def is_ascii_box(content):
    return any(c in BOX_CHARS for c in content)


def is_tree_diagram(content):
    """Check if box contains tree structure with connectors."""
    tree_chars = {"│", "├", "┤", "└", "┘", "┬"}
    return any(c in tree_chars for c in content)


def extract_box_content(lines):
    title = None
    content_lines = []
    in_box = False

    for line in lines:
        stripped = line.strip()
        if stripped and all(c in "┌┐└┘│─├┤┬┴┼" or c == " " for c in stripped):
            in_box = True
            continue

        if in_box:
            clean = line.replace("│", "").replace("├", "").replace("┤", "").strip()
            if clean:
                if title is None and len(clean) < 40:
                    title = clean
                else:
                    content_lines.append(clean)

    if not title:
        title = "内容"

    return title, content_lines


def extract_box_raw(lines):
    """Extract raw box content including diagram."""
    title = None
    raw_lines = []
    in_box = False
    title_found = False

    for line in lines:
        stripped = line.strip()
        if stripped and all(c in "┌┐└┘│─├┤┬┴┼" or c == " " for c in stripped):
            in_box = True
            raw_lines.append(line)
            if not title_found:
                continue
            continue

        if in_box:
            raw_lines.append(line)
            if not title_found:
                for c in "┌┐├┬":
                    if c in line:
                        continue
                clean = line.replace("│", "").replace("├", "").replace("┤", "").strip()
                if clean and len(clean) < 40:
                    title = clean
                    title_found = True

    if not title:
        title = "内容"

    return title, raw_lines


LATEX_TEMPLATE = r"""\documentclass[12pt,a4paper]{article}
\usepackage{fontspec}
\setmainfont{STHeiti}
\newfontfamily\chinesefont{STHeiti}
\usepackage{geometry}
\geometry{margin=1in}
\usepackage{xcolor}
\usepackage{amsmath}
\usepackage{hyperref}
\hypersetup{colorlinks=true,linkcolor=blue}

\newenvironment{modernbox}[1]{%
  \begin{trivlist}\item[\hskip\labelsep \textbf{#1:}]%
}{%
  \end{trivlist}%
}

\DeclareTextFontCommand{\textbf}{\bfseries}
\DeclareTextFontCommand{\emph}{\itshape}

\begin{document}

\title{%(title)s}
\author{}
\date{}

%(content)s

\end{document}
"""

CSS_STYLE = """
<style>
  * { box-sizing: border-box; }
  body { 
    font-family: "PingFang SC", "Microsoft YaHei", "Hiragino Sans GB", sans-serif;
    line-height: 1.8;
    color: #333;
    max-width: 900px;
    margin: 0 auto;
    padding: 40px 20px;
  }
  h1 { color: #1a365d; border-bottom: 3px solid #2c5282; padding-bottom: 10px; }
  h2 { color: #2c5282; margin-top: 30px; }
  h3 { color: #2b6cb0; }
  h4 { color: #3182ce; }
  table { border-collapse: collapse; width: 100%; margin: 20px 0; }
  th, td { border: 1px solid #ddd; padding: 10px 12px; text-align: left; }
  th { background: #2c5282; color: white; }
  tr:nth-child(even) { background: #f7fafc; }
  .box-container { margin: 25px 0; }
  .box { 
    border: 3px solid #2c5282; 
    border-radius: 8px; 
    overflow: hidden;
    background: #fff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  }
  .box-header { 
    background: linear-gradient(135deg, #2c5282 0%, #1a365d 100%);
    color: white;
    padding: 15px 20px;
    font-size: 18px;
    font-weight: bold;
  }
  .box-body { 
    padding: 20px; 
    border-top: 2px solid #4299e1;
    background: #f7fafc;
  }
  .box-body p { margin: 8px 0; font-size: 15px; color: #2d3748; }
  .diagram { 
    background: #1a202c; 
    color: #e2e8f0; 
    padding: 20px; 
    border-radius: 8px;
    overflow-x: auto;
    font-family: "Courier New", monospace;
    font-size: 13px;
    line-height: 1.4;
    white-space: pre;
  }
  code { background: #edf2f7; padding: 2px 6px; border-radius: 3px; }
  pre { background: #2d3748; color: #e2e8f0; padding: 15px; border-radius: 5px; overflow-x: auto; }
  hr { border: none; border-top: 2px solid #e2e8f0; margin: 30px 0; }
  ul, ol { margin: 10px 0; padding-left: 25px; }
  li { margin: 5px 0; }
</style>
"""


def convert_markdown_table_to_html(table_text):
    """Convert markdown table to HTML table."""
    lines = table_text.strip().split("\n")
    if len(lines) < 3:
        return table_text

    header_row = None
    separator_row = None
    data_rows = []

    for line in lines:
        if "|" in line:
            if "---" in line:
                separator_row = line
                continue
            cells = [c.strip() for c in line.split("|")[1:-1]]
            if header_row is None:
                header_row = cells
            else:
                data_rows.append(cells)

    if not header_row:
        return table_text

    html = "<table>\n"
    html += "  <thead><tr>"
    for cell in header_row:
        html += f"<th>{cell}</th>"
    html += "</tr></thead>\n"

    html += "  <tbody>\n"
    for row in data_rows:
        html += "    <tr>"
        for cell in row:
            html += f"<td>{cell}</td>"
        html += "</tr>\n"
    html += "  </tbody>\n</table>"

    return html


def process_markdown_to_latex(md_path, output_dir):
    """Convert markdown with boxes to LaTeX."""
    os.makedirs(output_dir, exist_ok=True)

    with open(md_path, "r", encoding="utf-8") as f:
        content = f.read()

    base_name = Path(md_path).stem

    title_match = re.search(r"^# (.+)$", content, re.MULTILINE)
    title = title_match.group(1) if title_match else base_name

    pattern = r"```\s*\n([\s\S]*?)\n```"

    def replace_box(match):
        block = match.group(1)
        if not is_ascii_box(block):
            return match.group(0)

        lines = block.split("\n")

        if is_tree_diagram(block):
            box_title, raw_lines = extract_box_raw(lines)
            raw_content = "\n".join(raw_lines)
            raw_content = (
                raw_content.replace("&", "\\&").replace("%", "\\%").replace("_", "\\_")
            )
            return f"\\begin{{verbatim}}\n{raw_content}\\end{{verbatim}}"

        box_title, content_lines = extract_box_content(lines)
        content_tex = " \\\\\n".join(content_lines)
        content_tex = (
            content_tex.replace("&", "\\&").replace("%", "\\%").replace("_", "\\_")
        )

        return f"\\begin{{modernbox}}{{{box_title}}}\n{content_tex}\\end{{modernbox}}"

    new_content = re.sub(pattern, replace_box, content)

    table_pattern = r"(\|.+\|\n)+"

    def replace_table(match):
        return convert_markdown_table_to_html(match.group(0))

    new_content = re.sub(table_pattern, replace_table, new_content)

    new_content = re.sub(
        r"^#### (.+)$", r"\\subsubsection{\1}", new_content, flags=re.MULTILINE
    )
    new_content = re.sub(
        r"^### (.+)$", r"\\subsection{\1}", new_content, flags=re.MULTILINE
    )
    new_content = re.sub(
        r"^## (.+)$", r"\\section{\1}", new_content, flags=re.MULTILINE
    )
    new_content = re.sub(
        r"^# (.+)$", r"\\title{\1}\\maketitle\\newpage", new_content, flags=re.MULTILINE
    )
    new_content = re.sub(r"\*\*(.+?)\*\*", r"\\textbf{\1}", new_content)
    new_content = re.sub(r"\*(.+?)\*", r"\\emph{\1}", new_content)
    new_content = re.sub(r"^- (.+)$", r"\\item \1", new_content, flags=re.MULTILINE)
    new_content = (
        new_content.replace("&", "\\&").replace("%", "\\%").replace("_", "\\_")
    )

    latex = LATEX_TEMPLATE.replace("%(title)s", title).replace(
        "%(content)s", new_content
    )

    tex_path = os.path.join(output_dir, f"{base_name}.tex")
    with open(tex_path, "w", encoding="utf-8") as f:
        f.write(latex)

    return tex_path


def process_markdown_to_html(md_path, output_dir):
    """Convert markdown with boxes to styled HTML."""
    os.makedirs(output_dir, exist_ok=True)

    with open(md_path, "r", encoding="utf-8") as f:
        content = f.read()

    base_name = Path(md_path).stem

    pattern = r"```\s*\n([\s\S]*?)\n```"

    def replace_box(match):
        block = match.group(1)
        if not is_ascii_box(block):
            return match.group(0)

        lines = block.split("\n")

        if is_tree_diagram(block):
            box_title, raw_lines = extract_box_raw(lines)
            raw_content = "".join(raw_lines)
            return f"""<div class="box-container">
  <div class="box">
    <div class="box-header">{box_title}</div>
    <div class="diagram">{raw_content}</div>
  </div>
</div>"""

        box_title, content_lines = extract_box_content(lines)
        content_html = "".join(f"<p>{line}</p>" for line in content_lines)

        return f"""<div class="box-container">
  <div class="box">
    <div class="box-header">{box_title}</div>
    <div class="box-body">
      {content_html}
    </div>
  </div>
</div>"""

    new_content = re.sub(pattern, replace_box, content)

    table_pattern = r"(\|.+\|\n)+"

    def replace_table(match):
        return convert_markdown_table_to_html(match.group(0))

    new_content = re.sub(table_pattern, replace_table, new_content)

    new_content = re.sub(r"^### (.+)$", r"<h3>\1</h3>", new_content, flags=re.MULTILINE)
    new_content = re.sub(r"^## (.+)$", r"<h2>\1</h2>", new_content, flags=re.MULTILINE)
    new_content = re.sub(r"^# (.+)$", r"<h1>\1</h1>", new_content, flags=re.MULTILINE)
    new_content = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", new_content)

    unordered_list_pattern = r"(?:^|\n)([-*] .+(?:\n[-*] .+)*)"

    def replace_ul(match):
        items = re.sub(
            r"^[-*] (.+)$", r"<li>\1</li>", match.group(0), flags=re.MULTILINE
        )
        return f"<ul>{items}</ul>"

    new_content = re.sub(unordered_list_pattern, replace_ul, new_content)

    ordered_list_pattern = r"(?:^|\n)(\d+\. .+(?:\n\d+\. .+)*)"

    def replace_ol(match):
        items = re.sub(
            r"^\d+\. (.+)$", r"<li>\1</li>", match.group(0), flags=re.MULTILINE
        )
        return f"<ol>{items}</ol>"

    new_content = re.sub(ordered_list_pattern, replace_ol, new_content)

    html = f"""<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>{base_name}</title>
  {CSS_STYLE}
</head>
<body>
{new_content}
</body>
</html>"""

    html_path = os.path.join(output_dir, f"{base_name}.html")
    with open(html_path, "w", encoding="utf-8") as f:
        f.write(html)

    return html_path


def convert_latex_to_pdf(tex_path, output_dir):
    """Compile LaTeX to PDF."""
    base_name = Path(tex_path).stem
    xelatex_cmd = "/Library/TeX/texbin/xelatex"

    if not os.path.exists(xelatex_cmd):
        print("  XeLaTeX not found")
        return None

    try:
        result = subprocess.run(
            [
                xelatex_cmd,
                "-interaction=nonstopmode",
                "-output-directory",
                output_dir,
                tex_path,
            ],
            capture_output=True,
            text=True,
            timeout=120,
        )
        pdf_path = os.path.join(output_dir, f"{base_name}.pdf")
        if os.path.exists(pdf_path):
            print(f"  ✓ {base_name}.pdf (XeLaTeX)")
            return pdf_path
        else:
            print(f"  ✗ PDF failed")
            return None
    except Exception as e:
        print(f"  Error: {e}")
    return None


def convert_to_docx(md_path, output_dir):
    """Convert markdown to DOCX."""
    base_name = Path(md_path).stem
    output_path = os.path.join(output_dir, f"{base_name}.docx")

    try:
        result = subprocess.run(
            ["pandoc", md_path, "-o", output_path, "--standalone"],
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode == 0 and os.path.exists(output_path):
            print(f"  ✓ {base_name}.docx")
            return output_path
    except Exception as e:
        print(f"  Error: {e}")
    return None


def convert_to_pptx(md_path, output_dir):
    """Convert markdown to PPTX."""
    base_name = Path(md_path).stem
    output_path = os.path.join(output_dir, f"{base_name}.pptx")

    try:
        result = subprocess.run(
            ["pandoc", "-t", "pptx", md_path, "-o", output_path],
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode == 0 and os.path.exists(output_path):
            print(f"  ✓ {base_name}.pptx")
            return output_path
    except Exception as e:
        print(f"  Error: {e}")
    return None


def convert_html_to_pdf_libreoffice(html_path, output_dir):
    """Convert HTML to PDF via LibreOffice."""
    base_name = Path(html_path).stem

    lo_paths = ["/Applications/LibreOffice.app/Contents/MacOS/soffice"]
    lo_cmd = None
    for p in lo_paths:
        if os.path.exists(p):
            lo_cmd = p
            break

    if not lo_cmd:
        return None

    try:
        subprocess.run(
            [
                lo_cmd,
                "--headless",
                "--convert-to",
                "pdf",
                "--outdir",
                output_dir,
                html_path,
            ],
            capture_output=True,
            text=True,
            timeout=120,
        )
        pdf_path = os.path.join(output_dir, f"{base_name}_lo.pdf")
        lo_pdf = os.path.join(output_dir, f"{base_name}.pdf")
        if os.path.exists(lo_pdf):
            import shutil

            shutil.move(lo_pdf, pdf_path)
        if os.path.exists(pdf_path):
            print(f"  ✓ {base_name}_lo.pdf (LibreOffice)")
            return pdf_path
    except Exception as e:
        print(f"  Error: {e}")
    return None


def main():
    if len(sys.argv) < 2:
        print("Usage: boxesplus.py <markdown_file>")
        sys.exit(1)

    md_path = sys.argv[1]

    if not os.path.exists(md_path):
        print(f"Error: File not found: {md_path}")
        sys.exit(1)

    base_dir = os.path.dirname(os.path.abspath(md_path))
    base_name = Path(md_path).stem
    output_dir = os.path.join(base_dir, f"boxesplus_{base_name}")
    os.makedirs(output_dir, exist_ok=True)

    print(f"\nProcessing: {md_path}")
    print(f"Output: {output_dir}\n")

    print("=== Generating formats ===")

    print("\n1. LaTeX → PDF (XeLaTeX)")
    tex_path = process_markdown_to_latex(md_path, output_dir)
    convert_latex_to_pdf(tex_path, output_dir)

    print("\n2. HTML/CSS")
    html_path = process_markdown_to_html(md_path, output_dir)
    print(f"  ✓ {base_name}.html")

    print("\n3. HTML → PDF (LibreOffice)")
    convert_html_to_pdf_libreoffice(html_path, output_dir)

    print("\n4. Markdown → DOCX (Pandoc)")
    convert_to_docx(md_path, output_dir)

    print("\n5. Markdown → PPTX (Pandoc)")
    convert_to_pptx(md_path, output_dir)

    print(f"\n✓ Done! All files in: {output_dir}")


if __name__ == "__main__":
    main()
