# React Native Expo Skill for Claude Code

A comprehensive Claude Code skill for building React Native apps with:

- **Expo Router v4** — File-based navigation
- **NativeWind v4** — Tailwind CSS via `className` prop
- **React Native Reusables** — shadcn/ui components for React Native
- **Reanimated 3** — 60fps animations on the UI thread
- **Gesture Handler 2** — Pan, pinch, tap gestures
- **TypeScript** — Required throughout

## What's Inside

| File | Description |
|------|-------------|
| `SKILL.md` | Main skill file — stack overview, project structure, core setup, best practices |
| `references/nativewind-patterns.md` | NativeWind v4 complete guide (dark mode, states, platform selectors, theming, CSS variables) |
| `references/rnr-components.md` | All 19 React Native Reusables component APIs (Button → DropdownMenu) |
| `references/expo-router-patterns.md` | File-based routing, auth flows, nested navigation, deep linking |
| `references/reanimated-patterns.md` | Animation patterns, gesture integration, skeleton loaders, sheet animations |
| `references/styling-patterns.md` | Design tokens, dark mode, typography, spacing, flex cheatsheet |

## Usage with Claude Code

### Option 1: Project-level CLAUDE.md

Copy `SKILL.md` content into your project's `CLAUDE.md`:

```bash
cp SKILL.md /path/to/your-rn-project/CLAUDE.md
cp -r references/ /path/to/your-rn-project/references/
```

### Option 2: Global Claude Code context

Add to `~/.claude/CLAUDE.md` to use across all projects.

### Option 3: OpenClaw Skill

Place in `/opt/homebrew/lib/node_modules/openclaw/skills/react-native-expo/` for OpenClaw integration.

## Key Principles

- **Zero `StyleSheet.create`** — All styling via NativeWind `className`
- **RNR first** — Use React Native Reusables before writing custom components
- **Expo Router** — File-based routing, no React Navigation config boilerplate
- **CSS Variables** — Design tokens via `hsl(var(--primary))` in `tailwind.config.js`
- **Dark mode** — Automatic via `dark:` prefix and `useColorScheme()`
- **TypeScript** — All components fully typed

## Stack Versions

| Package | Version |
|---------|---------|
| expo | ~52.x |
| expo-router | ~4.x |
| nativewind | ^4.x |
| react-native-reusables | latest |
| react-native-reanimated | ~3.x |
| react-native-gesture-handler | ~2.x |
| tailwindcss | ^3.4.x |

## Quick Start

```bash
# New Expo project with NativeWind
npx create-expo-app my-app
cd my-app
npm install nativewind react-native-reanimated react-native-safe-area-context
npm install --save-dev tailwindcss@^3.4

# Add RNR components
npx @react-native-reusables/cli@latest init
npx @react-native-reusables/cli@latest add button card input dialog
```

## shadcn MCP Integration

Add to `components.json` to install RNR components via shadcn MCP:

```json
{
  "registries": {
    "@rnr": "https://reactnativereusables.com/r/nativewind/{name}.json"
  }
}
```

Then in Claude Code: *"Add @rnr/button and @rnr/card to my project"*

## Resources

- [NativeWind v4 Docs](https://www.nativewind.dev/docs)
- [React Native Reusables](https://reactnativereusables.com)
- [Expo Router Docs](https://docs.expo.dev/router/introduction)
- [Reanimated 3 Docs](https://docs.swmansion.com/react-native-reanimated/)
- [Gesture Handler Docs](https://docs.swmansion.com/react-native-gesture-handler/)

## License

MIT
