# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a GitHub profile README repository (github.com/druce/druce) that displays on the profile page. It contains:
- A personal README.md with biographical information, tech stack badges, and a dynamic quote section
- Automation scripts (Python and bash) to update the quote daily via GitHub Actions
- Profile banner images

## Key Commands

### Update README with Random Quote

**Python script (recommended):**
```bash
python update_quote.py
```

**Bash script (legacy):**
```bash
./update_quote.sh
```

Both scripts:
- Select a random quote from `.fortune_mission` (fortune cookie format with `%` separators)
- Update the quote between `<!-- QUOTE:START -->` and `<!-- QUOTE:END -->` markers in README.md
- Format quotes as markdown blockquotes (prefixed with `>`)

The Python script is used by GitHub Actions for automated daily updates.

## Architecture

### Quote System
The quote rotation system uses a fortune file format:
- `.fortune_mission` contains quotes separated by `%` on its own line
- The update script counts separators to randomly select one quote
- Quotes are formatted as markdown blockquotes (prefixed with `>`)
- The README contains HTML comment markers to identify replacement zones

### README Structure
The README.md has protected zones for dynamic content:
- `<!-- QUOTE:START -->` ... `<!-- QUOTE:END -->`: Daily rotating quote

When editing README.md, preserve these markers and their content formatting to maintain compatibility with the update scripts.

### GitHub Actions
A workflow runs daily at 1:00 AM UTC to automatically update the quote:
- `.github/workflows/update-quote.yml` - Runs `update_quote.py` and commits changes
- Can be manually triggered via the Actions tab

### Image Assets
- `github_banner.jpg`: Optimized banner image displayed in README
- Source/working image files are gitignored (see .gitignore for patterns)
