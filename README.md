# Agent Skills

Reusable AI agent skill definitions for multiple tools. Install once, use across Claude Code, Gemini CLI, GitHub Copilot, and Antigravity.

## Available Skills

| Skill | Description |
|-------|-------------|
| `react-native-expo` | Expert React Native development with Expo Router, NativeWind v4, and React Native Reusables |
| `remotion` | Best practices for Remotion — video creation in React |

## Installation

### macOS / Linux

```bash
git clone https://github.com/mumudevx/agent-skills.git
cd agent-skills
chmod +x install.sh

# Install all skills for all tools
./install.sh --tool all

# Single tool
./install.sh --tool claude

# Single skill
./install.sh --tool claude --skill remotion

# List skills
./install.sh --list

# Uninstall
./install.sh --uninstall --tool claude
./install.sh --uninstall --tool all
```

### Windows (PowerShell)

> Requires PowerShell 5.1+ and **Administrator** privileges (for symlink creation).

```powershell
git clone https://github.com/mumudevx/agent-skills.git
cd agent-skills

# Install all skills for all tools
.\install.ps1 -Tool all

# Single tool
.\install.ps1 -Tool claude

# Single skill
.\install.ps1 -Tool gemini -Skill remotion

# List skills
.\install.ps1 -List

# Uninstall
.\install.ps1 -Uninstall -Tool claude
.\install.ps1 -Uninstall -Tool all
```

## Supported Tools

| Tool | macOS / Linux | Windows |
|------|--------------|---------|
| Claude Code | `~/.claude/skills/` | `%USERPROFILE%\.claude\skills\` |
| Gemini CLI | `~/.gemini/skills/` | `%USERPROFILE%\.gemini\skills\` |
| GitHub Copilot | `~/.copilot/skills/` | `%USERPROFILE%\.copilot\skills\` |
| Antigravity | `~/.gemini/antigravity/skills/` | `%USERPROFILE%\.gemini\antigravity\skills\` |

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
