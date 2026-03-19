---
name: animations-integration
description: Reanimated 3 vs Remotion animation system — correct integration patterns
metadata:
  tags: react-native, remotion, animations, reanimated, spring, interpolate
---

## Animations in Remotion with React Native

Remotion has its own animation system driven by `useCurrentFrame()`. Do **not** use `react-native-reanimated` for Remotion video animations. Reanimated runs on the UI thread and is designed for interactive 60fps animations, while Remotion needs deterministic, frame-accurate, JS-driven animations for video rendering.

### Why Not Reanimated?

- Reanimated's `withSpring`, `withTiming`, and shared values run on the native UI thread, outside React's render cycle.
- Remotion renders each frame independently and needs the animation state to be a pure function of the frame number.
- Using Reanimated will produce non-deterministic output where frames may not match the expected animation state.

### The Correct Approach

Use `useCurrentFrame()`, `interpolate()`, and `spring()` from Remotion. These are pure functions of the frame number, guaranteeing frame-accurate output.

```tsx
// ❌ WRONG: Do not use Reanimated in Remotion compositions
import Animated, { withSpring } from "react-native-reanimated";

// ✅ CORRECT: Use Remotion's animation system
import { useCurrentFrame, interpolate, spring, useVideoConfig } from "remotion";

export const AnimatedElement: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const scale = spring({ frame, fps, config: { damping: 10 } });
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <div style={{ transform: `scale(${scale})`, opacity }}>
      <h1>Animated Title</h1>
    </div>
  );
};
```

### Remotion Animation Primitives

**interpolate:** Maps a frame range to an output range. Use `extrapolateRight: "clamp"` to prevent values from exceeding the output range.

```tsx
const frame = useCurrentFrame();

// Fade in over 30 frames
const opacity = interpolate(frame, [0, 30], [0, 1], {
  extrapolateRight: "clamp",
});

// Slide in from the right over frames 10-40
const translateX = interpolate(frame, [10, 40], [200, 0], {
  extrapolateLeft: "clamp",
  extrapolateRight: "clamp",
});
```

**spring:** Physics-based spring animation. Returns a value that settles to 1.

```tsx
const { fps } = useVideoConfig();
const frame = useCurrentFrame();

const scale = spring({
  frame,
  fps,
  config: {
    damping: 12,
    stiffness: 200,
    mass: 0.5,
  },
});

// Delayed spring (starts at frame 20)
const delayedScale = spring({
  frame: frame - 20,
  fps,
  config: { damping: 10 },
});
```

### Combining Multiple Animations

```tsx
import { useCurrentFrame, useVideoConfig, interpolate, spring } from "remotion";
import { View, Text, StyleSheet } from "react-native";

export const MultiAnimation: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const titleSpring = spring({ frame, fps, config: { damping: 12 } });
  const subtitleOpacity = interpolate(frame, [20, 50], [0, 1], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  const subtitleY = interpolate(frame, [20, 50], [30, 0], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  return (
    <View style={styles.container}>
      <Text
        style={[
          styles.title,
          { transform: [{ scale: titleSpring }] },
        ]}
      >
        Welcome
      </Text>
      <Text
        style={[
          styles.subtitle,
          {
            opacity: subtitleOpacity,
            transform: [{ translateY: subtitleY }],
          },
        ]}
      >
        To the video
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    backgroundColor: "#000",
  },
  title: {
    fontSize: 72,
    fontWeight: "bold",
    color: "#ffffff",
  },
  subtitle: {
    fontSize: 32,
    color: "#aaaaaa",
    marginTop: 16,
  },
});
```

### When Gestures Are Acceptable

For **player controls** (not video content), gesture libraries like `react-native-gesture-handler` can be used to build interactive play/pause buttons, scrubbers, or seek controls. These run outside the composition and do not affect the rendered video.

### Key Rules

- Never use `react-native-reanimated` inside Remotion compositions.
- Use `useCurrentFrame()` as the single source of truth for all animations.
- Use `interpolate()` for linear/clamped animations and `spring()` for physics-based motion.
- `spring()` from Remotion replaces Reanimated's `withSpring`.
- Gesture-based interactions are only relevant for player UI, not for video content.
