---
name: flexbox-layout
description: Flexbox layout patterns for video composition sizing and positioning
metadata:
  tags: react-native, remotion, flexbox, layout, positioning, composition
---

## Flexbox Layout in Remotion Compositions

React Native uses flexbox by default for layout. A critical difference from web CSS is that `flexDirection` defaults to `"column"` (not `"row"`). Understanding this is important when building Remotion compositions with React Native components.

### Filling the Composition Area

Use `flex: 1` on your root `View` to fill the entire composition dimensions (e.g., 1920x1080).

```tsx
import { useCurrentFrame, interpolate, useVideoConfig } from "remotion";
import { View, Text, StyleSheet } from "react-native";

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#1a1a2e",
  },
  header: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  body: {
    flex: 2,
    flexDirection: "row",
    justifyContent: "space-evenly",
    alignItems: "center",
  },
  card: {
    width: 300,
    height: 400,
    backgroundColor: "#16213e",
    borderRadius: 16,
    justifyContent: "center",
    alignItems: "center",
  },
  footer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
});

export const LayoutComposition: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const headerOpacity = interpolate(frame, [0, fps * 0.5], [0, 1], {
    extrapolateRight: "clamp",
  });

  const cardScale = interpolate(frame, [fps * 0.3, fps * 0.8], [0.8, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <View style={styles.container}>
      <View style={[styles.header, { opacity: headerOpacity }]}>
        <Text style={{ fontSize: 56, color: "#e94560", fontWeight: "bold" }}>
          Video Title
        </Text>
      </View>

      <View style={styles.body}>
        {["Card 1", "Card 2", "Card 3"].map((label, i) => (
          <View
            key={label}
            style={[styles.card, { transform: [{ scale: cardScale }] }]}
          >
            <Text style={{ fontSize: 28, color: "#ffffff" }}>{label}</Text>
          </View>
        ))}
      </View>

      <View style={styles.footer}>
        <Text style={{ fontSize: 20, color: "#888888" }}>
          Frame {frame}
        </Text>
      </View>
    </View>
  );
};
```

### Common Patterns

**Centering content:**
```tsx
<View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
  <Text>Centered</Text>
</View>
```

**Grid layout:**
```tsx
<View style={{ flex: 1, flexDirection: "row", flexWrap: "wrap" }}>
  {items.map((item) => (
    <View key={item.id} style={{ width: "50%", height: "50%" }}>
      {/* Quarter of the composition */}
    </View>
  ))}
</View>
```

**Overlapping layers with position absolute:**
```tsx
<View style={{ flex: 1 }}>
  {/* Background layer */}
  <View style={StyleSheet.absoluteFill}>
    <Text>Background</Text>
  </View>
  {/* Foreground layer */}
  <View style={[StyleSheet.absoluteFill, { justifyContent: "flex-end", padding: 40 }]}>
    <Text style={{ fontSize: 32, color: "white" }}>Overlay Text</Text>
  </View>
</View>
```

### Key Rules

- Remember `flexDirection` defaults to `"column"` in React Native.
- Use `flex: 1` on the root container to fill the composition area.
- Use `position: "absolute"` and `StyleSheet.absoluteFill` for layered compositions.
- Match your flex layout proportions to the composition dimensions for predictable output.
