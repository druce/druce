#!/usr/bin/env python3
"""Update README.md with a random quote from fortune file."""

import random
import re
from pathlib import Path


def read_fortune_file(fortune_path: Path) -> list[str]:
    """Read fortune file and return list of quotes."""
    if not fortune_path.exists():
        raise FileNotFoundError(f"Fortune file not found at {fortune_path}")

    content = fortune_path.read_text(encoding='utf-8')

    # Split by % separator and filter out empty quotes
    quotes = [q.strip() for q in content.split('%') if q.strip()]

    if not quotes:
        raise ValueError("No quotes found in fortune file")

    return quotes


def format_quote_as_blockquote(quote: str) -> str:
    """Format quote as markdown blockquote."""
    lines = quote.split('\n')
    return '\n'.join(f'> {line}' for line in lines)


def update_readme(readme_path: Path, new_quote: str) -> None:
    """Update README.md with new quote between markers."""
    if not readme_path.exists():
        raise FileNotFoundError(f"README file not found at {readme_path}")

    content = readme_path.read_text(encoding='utf-8')

    # Pattern to match content between quote markers
    pattern = r'(<!-- QUOTE:START -->)\n.*?\n(<!-- QUOTE:END -->)'

    # Replace with new quote
    replacement = f'\\1\n{new_quote}\n\\2'
    new_content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    # Write updated content
    readme_path.write_text(new_content, encoding='utf-8')


def main():
    """Main function to update README with random quote."""
    script_dir = Path(__file__).parent
    fortune_file = script_dir / '.fortune_mission'
    readme_file = script_dir / 'README.md'

    try:
        # Read all quotes
        quotes = read_fortune_file(fortune_file)

        # Select random quote
        selected_quote = random.choice(quotes)

        # Format as blockquote
        formatted_quote = format_quote_as_blockquote(selected_quote)

        # Update README
        update_readme(readme_file, formatted_quote)

        print("README updated successfully with a new quote!")

    except Exception as e:
        print(f"Error: {e}")
        raise


if __name__ == '__main__':
    main()
