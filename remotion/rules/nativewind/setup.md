---
name: setup
description: NativeWind + Remotion project configuration for Expo-based video rendering
metadata:
  tags: nativewind, remotion, setup, metro, babel, tailwind, expo, configuration
---

## NativeWind + Remotion Project Setup

NativeWind brings Tailwind CSS utility classes to React Native. When used within Remotion compositions (especially Expo-based Remotion projects), both build systems must coexist. Remotion uses webpack by default, but NativeWind requires Metro — so this setup applies to Expo-based Remotion projects.

### Metro Configuration

NativeWind requires wrapping the Metro config with `withNativeWind`. This tells Metro to process the global CSS file containing Tailwind directives.

```javascript
// metro.config.js
const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require("nativewind/metro");

const config = getDefaultConfig(__dirname);

module.exports = withNativeWind(config, { input: "./global.css" });
```

### Babel Configuration

The Babel config must include the `nativewind/babel` preset and set `jsxImportSource` to `"nativewind"` so that className props are transformed correctly at build time.

```javascript
// babel.config.js
module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ["babel-preset-expo", { jsxImportSource: "nativewind" }],
      "nativewind/babel",
    ],
  };
};
```

### Global CSS File

Create a `global.css` file at the project root with the standard Tailwind directives. This file must be imported at your app entry point.

```css
/* global.css */
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Tailwind Configuration

The `content` paths in `tailwind.config.js` must include all directories containing Remotion composition files so that Tailwind can scan for class usage.

```javascript
// tailwind.config.js
module.exports = {
  content: [
    "./app/**/*.{js,jsx,ts,tsx}",
    "./components/**/*.{js,jsx,ts,tsx}",
    "./remotion/**/*.{js,jsx,ts,tsx}",
    "./src/compositions/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
```

### Entry Point Import

Make sure `global.css` is imported at the root of your application so the styles are available to all Remotion compositions.

```tsx
// App.tsx or app/_layout.tsx
import "./global.css";
```

### Key Points

- NativeWind requires Metro, not webpack — this setup applies to Expo-based Remotion projects.
- Both Expo and Remotion configurations must coexist without conflicting.
- The `jsxImportSource: "nativewind"` setting is critical for className transformation.
- Tailwind config content paths must cover all Remotion composition file locations.
