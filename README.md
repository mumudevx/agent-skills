# Agent Skills

Reusable AI agent skill definitions for multiple tools. Install once, use across Claude Code, Gemini CLI, GitHub Copilot, and Antigravity.

## Available Skills

| Skill | Description |
|-------|-------------|
| `react-native-expo` | Expert React Native development with Expo Router, NativeWind v4, and React Native Reusables |
| `remotion` | Best practices for Remotion — video creation in React |

## Installation

### Prerequisites

- macOS / Linux
- Bash 4+

### Quick Start

```bash
# Clone the repo
git clone https://github.com/mumudevx/agent-skills.git
cd agent-skills

# Make the installer executable
chmod +x install.sh

# Install all skills for all tools
./install.sh --tool all
```

### Install for a Specific Tool

```bash
./install.sh --tool claude
./install.sh --tool gemini
./install.sh --tool copilot
./install.sh --tool antigravity
```

### Install a Specific Skill

```bash
./install.sh --tool claude --skill remotion
```

### List Available Skills

```bash
./install.sh --list
```

## Uninstall

```bash
# Remove from a specific tool
./install.sh --uninstall --tool claude

# Remove from all tools
./install.sh --uninstall --tool all
```

## Supported Tools

| Tool | Skill Directory |
|------|----------------|
| Claude Code | `~/.claude/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| GitHub Copilot | `~/.copilot/skills/` |
| Antigravity | `~/.gemini/antigravity/skills/` |

## Adding a New Skill

1. Create a new directory at the repo root (e.g. `my-skill/`)
2. Add a `SKILL.md` file with frontmatter:
   ```markdown
   ---
   name: my-skill
   description: Short description of what this skill does
   ---

   Skill content here...
   ```
3. Run `./install.sh --tool all` to install it everywhere

The installer automatically discovers any directory containing a `SKILL.md` file.
