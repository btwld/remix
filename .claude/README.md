# Claude Code Configuration

This directory contains team-wide Claude Code settings for the Remix project.

## Files

### settings.json (Team Settings)

Team-wide configuration that applies to all developers:

```json
{
  "hooks": {
    "sessionStart": "scripts/setup.sh"
  },
  "model": {
    "default": "sonnet"
  },
  "shell": {
    "defaultShell": "/bin/bash"
  }
}
```

**What it does:**
- Runs `scripts/setup.sh` automatically when Claude Code session starts
- Sets Sonnet as the default model
- Uses bash as the default shell

### settings.local.json (Personal Settings - Git Ignored)

You can create a `settings.local.json` file for personal overrides. This file is git-ignored and will not be committed.

**Example personal settings:**
```json
{
  "model": {
    "default": "opus"
  }
}
```

## Settings Precedence

Settings are loaded in this order (lowest to highest priority):

1. User global settings (`~/.claude/settings.json`)
2. Project team settings (`.claude/settings.json`) ← This file
3. Project local settings (`.claude/settings.local.json`) ← Your personal overrides
4. Command-line arguments
5. Enterprise policies

Higher priority settings override lower priority ones.

## Session Start Hook

The `sessionStart` hook runs `scripts/setup.sh` which:

1. Verifies AGENTS.md and CLAUDE.md exist
2. Configures PATH for pub-cache and FVM
3. Installs/verifies FVM (Flutter Version Management)
4. Installs Flutter via FVM (reads `.fvmrc`)
5. Installs/verifies Melos (monorepo workspace manager)
6. Installs/verifies DCM (Dart Code Metrics)
7. Bootstraps workspace (`melos bootstrap`)
8. Verifies setup with Flutter doctor

This ensures Claude Code has a fully configured environment ready to work with the Remix project.

## Personal Overrides

To create personal settings that won't be committed:

```bash
# Create personal settings
cat > .claude/settings.local.json << 'EOF'
{
  "model": {
    "default": "opus"
  }
}
EOF
```

This is already git-ignored, so it won't be committed to the repository.

## Documentation

For more information about Claude Code configuration:
- **Claude Code Docs:** https://docs.claude.com/en/docs/claude-code
- **Settings Reference:** https://docs.claude.com/en/docs/claude-code/settings.md
- **Hooks Documentation:** https://docs.claude.com/en/docs/claude-code/hooks.md
