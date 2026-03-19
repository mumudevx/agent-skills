---
name: performance
description: React.memo, FlatList alternatives, useCallback, and optimization patterns for Remotion rendering
metadata:
  tags: react-native, remotion, performance, memo, optimization, calculateMetadata
---

## Performance Optimization in Remotion with React Native

Remotion re-renders your composition on every single frame. Optimizing render performance is critical for fast video output, especially for long compositions or complex visuals.

### React.memo for Static Elements

Use `React.memo` to prevent re-renders of components that do not depend on the current frame. This avoids unnecessary work on every frame.

```tsx
import React, { useMemo } from "react";
import { useCurrentFrame, interpolate, AbsoluteFill } from "remotion";
import { View, Text, StyleSheet } from "react-native";

const StaticBackground = React.memo(() => {
  return (
    <View style={styles.background}>
      <Text style={styles.watermark}>My Channel</Text>
    </View>
  );
});

const AnimatedTitle: React.FC<{ text: string }> = ({ text }) => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });
  const translateY = interpolate(frame, [0, 30], [40, 0], {
    extrapolateRight: "clamp",
  });

  return (
    <Text
      style={[
        styles.title,
        { opacity, transform: [{ translateY }] },
      ]}
    >
      {text}
    </Text>
  );
};

export const OptimizedComposition: React.FC<{ title: string; items: string[] }> = ({
  title,
  items,
}) => {
  const frame = useCurrentFrame();

  // useMemo for expensive derived data
  const processedItems = useMemo(() => {
    return items.map((item, i) => ({
      label: item.toUpperCase(),
      delay: i * 10,
    }));
  }, [items]);

  return (
    <AbsoluteFill>
      <StaticBackground />
      <View style={styles.content}>
        <AnimatedTitle text={title} />
        {processedItems.map((item) => {
          const itemOpacity = interpolate(
            frame,
            [item.delay, item.delay + 20],
            [0, 1],
            { extrapolateLeft: "clamp", extrapolateRight: "clamp" }
          );
          return (
            <Text key={item.label} style={[styles.item, { opacity: itemOpacity }]}>
              {item.label}
            </Text>
          );
        })}
      </View>
    </AbsoluteFill>
  );
};

const styles = StyleSheet.create({
  background: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: "#0a0a0a",
    justifyContent: "flex-end",
    alignItems: "flex-end",
    padding: 20,
  },
  watermark: {
    fontSize: 14,
    color: "#333333",
  },
  content: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 60,
  },
  title: {
    fontSize: 64,
    fontWeight: "bold",
    color: "#ffffff",
    marginBottom: 40,
  },
  item: {
    fontSize: 28,
    color: "#cccccc",
    marginVertical: 8,
  },
});
```

### FlatList is Not Recommended

Do **not** use `FlatList` in Remotion compositions. FlatList is designed for virtualized scrolling with user interaction, which does not exist in video rendering. Use simple `.map()` instead.

```tsx
// ❌ WRONG: FlatList in a composition
<FlatList data={items} renderItem={({ item }) => <Text>{item}</Text>} />

// ✅ CORRECT: Simple map
{items.map((item) => (
  <Text key={item.id}>{item.label}</Text>
))}
```

### calculateMetadata for Pre-computation

Use `calculateMetadata()` to pre-compute data before rendering begins. This avoids expensive calculations running on every frame.

```tsx
import { CalculateMetadataFunction } from "remotion";

type Props = { dataUrl: string; items?: string[] };

export const calculateMetadata: CalculateMetadataFunction<Props> = async ({
  props,
}) => {
  const response = await fetch(props.dataUrl);
  const data = await response.json();

  return {
    durationInFrames: data.items.length * 30,
    props: {
      ...props,
      items: data.items,
    },
  };
};
```

### delayRender for Async Operations

Use `delayRender` / `continueRender` when your composition needs to load async data before rendering can begin.

```tsx
import { delayRender, continueRender } from "remotion";
import { useState, useEffect } from "react";

const [handle] = useState(() => delayRender("Loading data"));

useEffect(() => {
  fetchData().then((data) => {
    setData(data);
    continueRender(handle);
  });
}, [handle]);
```

### Key Rules

- Use `React.memo` for components that do not depend on `useCurrentFrame()`.
- Use `useMemo` / `useCallback` for expensive computations or stable references.
- Never use `FlatList` — use `.map()` for lists.
- Pre-compute data with `calculateMetadata()` instead of computing in the render function.
- Use `delayRender` / `continueRender` for async operations.
