---
name: styling
description: StyleSheet.create, inline styles, and style prop differences in Remotion video rendering
metadata:
  tags: react-native, remotion, stylesheet, styles, css, inline-styles
---

## Styling in Remotion with React Native

In Remotion, styles are rendered in a browser environment. When using React Native Web, `StyleSheet.create` is translated to CSS under the hood. Understanding how styling works in this context is essential for correct video output.

### StyleSheet.create vs Inline Styles

`StyleSheet.create` provides type checking and minor performance optimizations by creating a static reference. Inline styles are re-created on every render, which happens on every frame in Remotion.

```tsx
import { useCurrentFrame, interpolate } from "remotion";
import { View, Text, StyleSheet } from "react-native";

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#0b0b0f",
  },
  title: {
    fontSize: 64,
    fontWeight: "bold",
    color: "#ffffff",
  },
  subtitle: {
    fontSize: 24,
    color: "#aaaaaa",
    marginTop: 12,
  },
});

export const StyledComposition: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });
  const translateY = interpolate(frame, [0, 30], [20, 0], {
    extrapolateRight: "clamp",
  });

  return (
    <View style={styles.container}>
      <Text style={[styles.title, { opacity }]}>Styled Title</Text>
      <Text
        style={[
          styles.subtitle,
          { opacity, transform: [{ translateY }] },
        ]}
      >
        Animated subtitle
      </Text>
    </View>
  );
};
```

### Transform Syntax

Avoid using CSS string syntax for transforms (e.g., `transform: "rotate(45deg)"`). React Native requires the array syntax:

```tsx
// ❌ WRONG: CSS string syntax
{ transform: "rotate(45deg) scale(1.2)" }

// ✅ CORRECT: React Native array syntax
{ transform: [{ rotate: "45deg" }, { scale: 1.2 }] }
```

### Animation Values

Use `interpolate()` from Remotion to compute animated style values. Do **not** use React Native's `Animated` API, as it is not frame-accurate and does not integrate with Remotion's rendering pipeline.

```tsx
import { interpolate, useCurrentFrame } from "remotion";

const frame = useCurrentFrame();
const scale = interpolate(frame, [0, 60], [0.5, 1], {
  extrapolateRight: "clamp",
});

// Apply to style
const animatedStyle = { transform: [{ scale }] };
```

### Key Rules

- Use `StyleSheet.create` for static styles to benefit from type safety and reuse.
- Use inline styles (or merged arrays) for dynamic, frame-driven values.
- Always use array syntax for `transform` properties.
- Derive all animated values from `useCurrentFrame()` and `interpolate()`.
