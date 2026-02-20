# Thoughts Directory Structure

This directory contains developer thoughts and notes for the open-mercato-ruby-sdk repository.
It is managed by the thoughts sync scripts and should not be committed to the code repository.

## Structure

- `lukasz/` - Your personal notes for this repository (symlink to ~/thoughts/repos/open-mercato-ruby-sdk/lukasz)
- `shared/` - Team-shared notes for this repository (symlink to ~/thoughts/repos/open-mercato-ruby-sdk/shared)
- `global/` - Cross-repository thoughts (symlink to ~/thoughts/global)
  - `lukasz/` - Personal notes that apply across all repositories
  - `shared/` - Team-shared notes that apply across all repositories

## Usage

Create markdown files in these directories to document:
- Architecture decisions
- Design notes
- TODO items
- Investigation results
- Any other development thoughts

Quick access:
- `thoughts/lukasz/` for your repo-specific notes (most common)
- `thoughts/shared/` for team-shared repo notes
- `thoughts/global/lukasz/` for your cross-repo notes

## Commands

- `thoughts-sync` - Commit and push thoughts changes
- `thoughts-status` - Show thoughts repository status

## Important

- Never commit the thoughts/ directory to your code repository
- Use `thoughts-sync` to manually sync changes
- Use `thoughts-status` to see sync status
