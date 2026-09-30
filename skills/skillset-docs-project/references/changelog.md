# Changelog

Source baseline: Keep a Changelog 1.1.0 (keepachangelog.com); Semantic Versioning 2.0.0 (semver.org).

## 1. File and format

- File is `CHANGELOG.md` at root; format based on Keep a Changelog, project adheres to SemVer — state both at the top.
- Sections per version, latest first, each with ISO date (`2026-03-14`); versions are linkable to tag comparisons.
- Groups in order: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`. Drop empty groups.

## 2. Unreleased habit

- Keep `## [Unreleased]` at the top; add entries with each PR instead of reconstructing at release time.
- At release, move Unreleased entries into a new dated version section.

## 3. Rules

- Human-curated highlights across commits — never paste raw `git log`.
- Deprecations, removals, and breaking changes are always listed loudly; yanked releases get a `[YANKED]` tag.
- Changelog entries reference the breaking commit or ADR where applicable, but stay readable alone.

## 4. Releases

- Tag versions per SemVer (`MAJOR.MINOR.PATCH`); host release notes may mirror the changelog section but the file stays canonical.
