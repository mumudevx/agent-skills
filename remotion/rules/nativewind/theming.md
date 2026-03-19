---
name: theming
description: CSS variables, design tokens, and dark mode for video theme systems
metadata:
  tags: nativewind, remotion, theming, css-variables, design-tokens, dark-mode, vars
---

## Theming in Remotion Compositions with NativeWind

NativeWind supports CSS custom properties (variables) for theming. In a Remotion video context, themes are typically fixed per render rather than toggled interactively. Use the `vars()` function from NativeWind to define theme tokens and apply them through Tailwind's arbitrary value syntax.

### Defining Themes with vars()

The `vars()` function creates a style object containing CSS custom properties that can be applied to a parent View. All children can reference these variables via Tailwind's arbitrary value syntax.

```tsx
import { vars } from "nativewind";
import { View, Text } from "react-native";

const brandTheme = vars({
  "--color-primary": "rgb(59, 130, 246)",
  "--color-secondary": "rgb(99, 102, 241)",
  "--color-bg": "rgb(15, 23, 42)",
});

const warmTheme = vars({
  "--color-primary": "rgb(245, 158, 11)",
  "--color-secondary": "rgb(239, 68, 68)",
  "--color-bg": "rgb(28, 25, 23)",
});

export const ThemedComposition: React.FC<{ theme?: "brand" | "warm" }> = ({
  theme = "brand",
}) => {
  const themeVars = theme === "brand" ? brandTheme : warmTheme;

  return (
    <View style={themeVars} className="flex-1 bg-[--color-bg]">
      <Text className="text-4xl font-bold text-[--color-primary]">
        Themed Video
      </Text>
      <Text className="mt-4 text-xl text-[--color-secondary]">
        Subtitle with theme color
      </Text>
    </View>
  );
};
```

### Tailwind Config with CSS Variable Tokens

Define color tokens in `tailwind.config.js` using CSS variable references so you can use semantic class names like `text-primary` instead of arbitrary values.

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: "var(--color-primary)",
        secondary: "var(--color-secondary)",
        surface: "var(--color-bg)",
      },
    },
  },
};
```

With this config, you can use `text-primary`, `bg-surface`, etc., and the actual color resolves from the CSS variables set by `vars()`.

```tsx
<View style={themeVars} className="flex-1 bg-surface">
  <Text className="text-4xl font-bold text-primary">Themed Title</Text>
</View>
```

### Per-Render Theme Selection

In Remotion, you typically pass the theme as an input prop to the composition. The theme is fixed for the entire render and does not change interactively.

```tsx
import { vars } from "nativewind";
import { View, Text } from "react-native";

const themes = {
  brand: vars({
    "--color-primary": "rgb(59, 130, 246)",
    "--color-bg": "rgb(15, 23, 42)",
  }),
  corporate: vars({
    "--color-primary": "rgb(16, 185, 129)",
    "--color-bg": "rgb(17, 24, 39)",
  }),
};

type ThemeName = keyof typeof themes;

export const VideoWithTheme: React.FC<{ themeName: ThemeName }> = ({
  themeName,
}) => {
  return (
    <View style={themes[themeName]} className="flex-1 items-center justify-center bg-[--color-bg]">
      <Text className="text-5xl font-bold text-[--color-primary]">
        Video Title
      </Text>
    </View>
  );
};
```

### Key Points

- Use `vars()` from NativeWind to define theme CSS variables.
- Apply theme vars via the `style` prop on a parent container.
- Reference variables in className with `text-[--color-name]` or `bg-[--color-name]` syntax.
- Define semantic color tokens in `tailwind.config.js` for cleaner class names.
- In video rendering, themes are fixed per render — not toggled interactively.
