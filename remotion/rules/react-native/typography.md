---
name: typography
description: Text component, font loading, and text measurement in Remotion context
metadata:
  tags: react-native, remotion, text, fonts, typography, font-loading
---

## Typography in Remotion with React Native

Text rendering in Remotion compositions using React Native requires understanding Text component nesting rules, Remotion-specific font loading, and layout measurement utilities.

### Text Component Nesting

In React Native, text must always be inside a `Text` component. You can nest `Text` inside `Text` for inline styling variations.

```tsx
import { View, Text, StyleSheet } from "react-native";
import { useCurrentFrame, interpolate } from "remotion";

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#0d0d0d",
    padding: 60,
  },
  paragraph: {
    fontSize: 32,
    color: "#cccccc",
    lineHeight: 48,
    textAlign: "center",
  },
  bold: {
    fontWeight: "bold",
    color: "#ffffff",
  },
  highlight: {
    color: "#ff6b6b",
    fontStyle: "italic",
  },
});

export const TypographyComposition: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 20], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <View style={styles.container}>
      <Text style={[styles.paragraph, { opacity }]}>
        This is a <Text style={styles.bold}>bold statement</Text> with{" "}
        <Text style={styles.highlight}>highlighted text</Text> inline.
      </Text>
    </View>
  );
};
```

### Font Loading

Use `@remotion/google-fonts` for Google Fonts or `staticFile()` for local font files. Do **not** use `expo-font` or React Native font loading mechanisms — they are not compatible with Remotion's rendering pipeline.

```tsx
import { loadFont } from "@remotion/google-fonts/Inter";
import { AbsoluteFill } from "remotion";
import { Text, View } from "react-native";

const { fontFamily } = loadFont();

export const FontComposition: React.FC = () => {
  return (
    <AbsoluteFill style={{ justifyContent: "center", alignItems: "center" }}>
      <Text style={{ fontFamily, fontSize: 48, color: "white" }}>
        Loaded with @remotion/google-fonts
      </Text>
    </AbsoluteFill>
  );
};
```

**Loading local fonts with staticFile:**

```tsx
import { staticFile, continueRender, delayRender } from "remotion";
import { useEffect, useState } from "react";

const waitForFont = delayRender();

const font = new FontFace("CustomFont", `url(${staticFile("fonts/Custom.woff2")})`);
font
  .load()
  .then(() => {
    document.fonts.add(font);
    continueRender(waitForFont);
  })
  .catch((err) => console.error("Font load error", err));
```

### Text Measurement

Use `@remotion/layout-utils` for measuring text dimensions. Do **not** rely on React Native's `onLayout` callback — it is asynchronous and not frame-accurate in the Remotion render pipeline.

```tsx
import { measureText } from "@remotion/layout-utils";

const measurement = measureText({
  text: "Hello World",
  fontFamily: "Inter",
  fontSize: 48,
  fontWeight: "bold",
});

console.log(measurement.width, measurement.height);
```

### Key Rules

- All visible text must be wrapped in a `Text` component.
- Use `Text` nesting for inline styling (bold, italic, colored spans).
- Load fonts via `@remotion/google-fonts` or `staticFile()` with the `FontFace` API.
- Never use `expo-font` or React Native font loading in Remotion.
- Measure text with `@remotion/layout-utils`, not `onLayout`.
