---
name: platform-specific
description: Platform.OS, platform selectors, and safe area considerations in Remotion video rendering
metadata:
  tags: react-native, remotion, platform, safe-area, cross-platform
---

## Platform-Specific Code in Remotion

Remotion renders video in a headless browser (Chromium). This means React Native's `Platform.OS` will always report `"web"` during rendering, and most platform-specific patterns are irrelevant for video output.

### Platform.OS in Remotion

Since Remotion uses a browser for rendering, platform detection will always return `"web"`. Platform-specific code targeting `"ios"` or `"android"` will never execute during video rendering.

```tsx
import { Platform } from "react-native";

// During Remotion rendering, this will always be "web"
console.log(Platform.OS); // "web"
```

### When Platform Code Matters

Platform-specific code is generally **not relevant** for Remotion video output. However, it can be relevant if you are building a **player UI** (the controls around the video, not the video content itself) that runs on different platforms.

```tsx
import { Platform, View, Text, StyleSheet } from "react-native";
import { Player } from "@remotion/player";
import { useCurrentFrame, AbsoluteFill } from "remotion";

// This composition renders identically on all platforms
export const VideoContent: React.FC = () => {
  const frame = useCurrentFrame();
  return (
    <AbsoluteFill style={{ backgroundColor: "#1a1a1a", justifyContent: "center", alignItems: "center" }}>
      <Text style={{ fontSize: 48, color: "white" }}>Frame {frame}</Text>
    </AbsoluteFill>
  );
};

// Player wrapper — here platform-specific code is acceptable
export const VideoPlayer: React.FC = () => {
  const playerHeight = Platform.select({
    web: 720,
    ios: 400,
    android: 400,
    default: 720,
  });

  return (
    <View style={styles.wrapper}>
      <Player
        component={VideoContent}
        compositionWidth={1920}
        compositionHeight={1080}
        durationInFrames={150}
        fps={30}
        style={{ width: "100%", height: playerHeight }}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  wrapper: {
    flex: 1,
    justifyContent: "center",
    backgroundColor: "#000",
  },
});
```

### Safe Area

Safe area concepts (`SafeAreaView`, `useSafeAreaInsets`) do **not** apply to video rendering. Videos have fixed dimensions defined by the composition config (e.g., 1920x1080). There are no notches, status bars, or navigation bars in rendered video.

If you need visual padding from the edges of the video frame, use explicit padding or margin values rather than safe area utilities.

```tsx
// ❌ WRONG: Safe area in a composition
import { SafeAreaView } from "react-native-safe-area-context";

// ✅ CORRECT: Explicit padding for video frame margins
<View style={{ flex: 1, padding: 60 }}>
  <Text style={{ color: "white" }}>Content with margin from edges</Text>
</View>
```

### Key Rules

- `Platform.OS` is always `"web"` in Remotion rendering. Do not branch composition logic on platform.
- Platform-specific code is only relevant for player UI wrappers, not video content.
- Do not use `SafeAreaView` or safe area insets in compositions. Use explicit padding instead.
- Keep composition components platform-agnostic for consistent video output.
