#!/usr/bin/env python3

# pylint: disable=locally-disabled, multiple-statements, fixme, line-too-long

"""
HTML Table to CSV Converter

This script parses an HTML file containing table(s) data, iterates over each table,
extracts rows and cells, reformats into CSV format with headers, and saves to output file.

Dependencies: beautifulsoup4 (install via pip install beautifulsoup4)
"""

import os
import argparse
from pathlib import Path
from typing import List, Optional
import csv
from bs4 import BeautifulSoup


def extract_tables_from_html(html_path: str) -> List[BeautifulSoup]:
    """
    Parse HTML file and return list of table elements.

    Args:
        html_path: Path to the HTML file

    Returns:
        List of BeautifulSoup objects representing each <table> element
    """
    with open(html_path, 'r', encoding='utf-8') as f:
        soup = BeautifulSoup(f.read(), 'html.parser')

    # Find all table elements, excluding any nested within other tables
    return [table for table in soup.find_all('table')]


def extract_row_data(row_tag) -> List[str]:
    """Extract text from all <td> and <th> cells in a row."""
    cells = []
    for cell in row_tag.find_all(['td', 'th']):
        cells.append(cell.get_text(strip=True))
    return cells


def get_table_headers(table: BeautifulSoup) -> Optional[List[str]]:
    """Extract headers from table's <thead> if present, otherwise use first row."""
    thead = table.find('thead')
    if thead and thead.find('tr'):
        return extract_row_data(thead.find('tr'))

    # Fallback to first data row as headers
    rows = table.find_all('tr', recursive=False)
    return extract_row_data(rows[0]) if rows else None


def tables_to_csv(tables: List[BeautifulSoup], output_path: str) -> int:
    """Convert all extracted tables to CSV format and save."""
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)

        for table in tables:
            headers = get_table_headers(table)
            if not headers:
                continue

            # Write header row
            writer.writerow(headers)

            # Write data rows (skip thead and first row which is already written as header)
            all_rows = table.find_all('tr', recursive=False)
            for row in all_rows[1:]:  # Skip header row
                cells = extract_row_data(row)
                if any(cells):  # Only write non-empty rows
                    writer.writerow(cells)

    return len(tables)


def html_to_csv(html_path: str, output_path: str) -> int:
    """
    Main conversion function. Reads HTML file with tables and outputs CSV.

    Args:
        html_path: Path to source HTML file
        output_path: Destination path for CSV (defaults to same name with .csv extension)

    Returns:
        Number of tables processed

    Raises:
        FileNotFoundError: If input file doesn't exist
        ValueError: For invalid inputs
    """
    if not os.path.isfile(html_path):
        raise FileNotFoundError(f"HTML file not found: {html_path}")

    output = Path(output_path) if output_path else Path(
        html_path).with_suffix('.csv')

    tables = extract_tables_from_html(html_path)
    if not tables:
        print("No <table> elements found in the HTML document.")
        return 0

    num_processed = tables_to_csv(tables, str(output))

    # Cleanup empty header-only rows from output file
    Path(output).unlink()
    with open(output, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        for table in tables:
            headers = get_table_headers(table)
            if not headers:
                continue
            writer.writerow(headers)
            rows = list(table.find_all('tr', recursive=False))
            for row in rows[1:]:
                cells = extract_row_data(row)
                if any(cells):
                    writer.writerow(cells)

    return num_processed


def main():
    """Entry point when run as script."""
    parser = argparse.ArgumentParser(
        description="Convert HTML tables to CSV format",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s input.html output.csv       # Custom output file name
  %(prog)s a.html                       # Auto-rename to a.csv (default)
  python -m html_to_csv src/index.html # Run as module

Output CSV files include headers from <thead> or first row, and all data rows.
Empty header-only tables are ignored.
        """
    )

    parser.add_argument(
        'input',
        help='Path to HTML file containing table(s)'
    )
    parser.add_argument(
        '-o', '--output',
        metavar='FILE',
        help='Output CSV filename (default: same name with .csv extension)',
        default=None
    )

    args = parser.parse_args()

    try:
        count = html_to_csv(args.input, args.output)
        print(
            f"Processed {count} table(s). Output saved to {args.output or Path(args.input).with_suffix('.csv')}")
    except FileNotFoundError as e:
        print(f"Error: {e}")
        return 1
    except Exception as e:
        print(f"Unexpected error: {e}")
        return 2

    return 0


if __name__ == '__main__':
    exit(main())
