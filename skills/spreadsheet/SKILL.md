---
name: spreadsheet
description: Use when tasks involve creating, editing, analyzing, or formatting spreadsheets (`.xlsx`, `.csv`, `.tsv`) with formula-aware workflows, cached recalculation, and visual review.
metadata:
  source: openai/skills spreadsheet listing
  source_url: https://skills.sh/openai/skills/spreadsheet
---

# Spreadsheet Skill

## When to use

- Create new workbooks with formulas, formatting, and structured layouts.
- Read or analyze tabular data by filtering, aggregating, pivoting, or computing metrics.
- Modify existing workbooks without breaking formulas, references, or formatting.
- Visualize data with charts, summary tables, and clear spreadsheet styling.
- Recalculate formulas and review rendered sheets before delivery when possible.

System and user instructions always take precedence.

## Workflow

1. Confirm the file type and goal: create, edit, analyze, or visualize.
2. Prefer `openpyxl` for `.xlsx` editing and formatting.
3. Use `pandas` for analysis and CSV/TSV workflows.
4. If recalculation/rendering tooling is available, recalculate formulas and render sheets before delivery.
5. Use formulas for derived values instead of hardcoding results.
6. If layout matters, render for visual review and inspect the output.
7. Save outputs with stable, descriptive filenames and clean up intermediate files.

## Primary tooling

- Use `openpyxl` for creating/editing `.xlsx` files while preserving formatting.
- Use `pandas` for analysis and tabular transformations.
- Use `openpyxl.chart` for native Excel charts when needed.
- If LibreOffice and Poppler are available, render sheets to PDF/PNG for visual checks.

## Formula requirements

- Preserve formulas when modifying existing workbooks.
- Prefer cell references over hardcoded constants.
- Use absolute and relative references carefully so copied formulas behave correctly.
- Guard against `#REF!`, `#DIV/0!`, `#VALUE!`, `#N/A`, and `#NAME?` errors.
- Check for off-by-one mistakes, circular references, and incorrect ranges.
- Avoid volatile functions like `INDIRECT` and `OFFSET` unless required.
- Avoid unsupported spreadsheet data-table features such as `=TABLE`.

## Formatting requirements

For existing spreadsheets:

- Render and inspect before modifying when possible.
- Preserve existing formatting and style exactly.
- Match styles for newly filled cells.
- Never overwrite established formatting unless the user explicitly asks for a redesign.

For new or unstyled spreadsheets:

- Use appropriate number, date, percentage, and currency formats.
- Make headers visually distinct from raw inputs and derived cells.
- Use fills, borders, spacing, and merged cells sparingly and intentionally.
- Set row heights and column widths so content is readable without excessive whitespace.
- Ensure text does not spill into adjacent cells.

## Color conventions

When no style guidance exists:

- Blue: user input.
- Black: formulas and derived values.
- Green: linked or imported values.
- Gray: static constants.
- Orange: review or caution.
- Light red: error or flag.
- Teal: KPI highlights and visualization anchors.

## Citation requirements

- Cite external data sources inside the spreadsheet using plain-text URLs.
- For financial models, cite model inputs in cell comments.
- For tabular data sourced externally, add a source column when each row represents a separate item.
