---
name: core-components
description: View, Text, Image, ScrollView usage in Remotion compositions for React Native
metadata:
  tags: react-native, remotion, view, text, image, scrollview, components
---

## Core Components in Remotion

When building Remotion compositions, you use standard HTML elements (`div`, `span`, `img`) by default. However, when targeting React Native environments (expo-video, React Native Web), you use React Native core components instead.

### Component Mapping

- **View** = Container element (equivalent to `div`). Use it to structure layout with flexbox.
- **Text** = Text display (equivalent to `span`/`p`). All text must be wrapped in a `Text` component in React Native.
- **Image** = Image display. Works with `require()` or URI sources, but prefer Remotion's `<Img>` for frame-accurate rendering.
- **ScrollView** = Scrollable container. Generally **NOT useful** in video rendering since there is no user interaction during render. Avoid it in compositions.

### Structuring a Composition with RN Components

Use `View` as your root layout container and `Text` for any visible text. Combine with Remotion hooks like `useCurrentFrame()` and `useVideoConfig()` to drive animations.

```tsx
import { useCurrentFrame, useVideoConfig, Img } from "remotion";
import { View, Text } from "react-native";

export const MyComposition: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const opacity = Math.min(1, frame / (fps * 0.5));

  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text style={{ fontSize: 48, color: "white", opacity }}>
        Hello from React Native
      </Text>
    </View>
  );
};
```

### Key Rules

- Always wrap text content in a `Text` component. Bare strings inside `View` will throw an error.
- Do not use `ScrollView` in compositions. The rendered video has no scroll interaction.
- Prefer Remotion's `<Img>` over React Native's `Image` when frame-accurate loading matters.
- Use `useCurrentFrame()` to derive all dynamic values — do not use React Native's `Animated` API.
