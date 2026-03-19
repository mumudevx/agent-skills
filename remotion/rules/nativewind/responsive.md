---
name: responsive
description: Breakpoints and responsive layout for different video resolutions
metadata:
  tags: nativewind, remotion, responsive, breakpoints, resolution, layout, video
---

## Responsive Layout for Video Resolutions

In Remotion, composition dimensions are fixed at render time — there is no viewport resizing. NativeWind's responsive breakpoints (`sm`, `md`, `lg`, `xl`, `2xl`) map to screen widths, but in video context these match the composition's resolution. For multi-resolution video support, use `useVideoConfig()` to adapt layout based on the composition's width and height.

### Resolution-Aware Components

Since Remotion compositions have fixed dimensions, use `useVideoConfig()` to determine the video format and apply conditional classes accordingly.

```tsx
import { useVideoConfig } from "remotion";
import { View, Text } from "react-native";

export const ResponsiveComposition: React.FC = () => {
  const { width, height } = useVideoConfig();
  const isVertical = height > width;

  return (
    <View className={`flex-1 p-8 ${isVertical ? "justify-end" : "justify-center"}`}>
      <Text className={`font-bold text-white ${isVertical ? "text-3xl" : "text-6xl"}`}>
        Responsive Title
      </Text>
    </View>
  );
};
```

### Custom Breakpoints for Video Resolutions

Configure custom breakpoints in `tailwind.config.js` that match common video resolutions instead of device screen sizes.

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    screens: {
      // Standard video resolutions as breakpoints
      "720p": "1280px",   // HD
      "1080p": "1920px",  // Full HD
      "4k": "3840px",     // Ultra HD
    },
    extend: {},
  },
};
```

### Multi-Format Layout

Build components that adapt to different video formats (landscape, portrait, square) using composition dimensions.

```tsx
import { useVideoConfig } from "remotion";
import { View, Text } from "react-native";

type VideoFormat = "landscape" | "portrait" | "square";

function getFormat(width: number, height: number): VideoFormat {
  if (width > height) return "landscape";
  if (height > width) return "portrait";
  return "square";
}

export const MultiFormatScene: React.FC = () => {
  const { width, height } = useVideoConfig();
  const format = getFormat(width, height);

  return (
    <View
      className={`flex-1 bg-slate-900 p-8 ${
        format === "landscape"
          ? "flex-row items-center gap-12"
          : "items-center justify-center gap-6"
      }`}
    >
      <View className="rounded-2xl bg-blue-600 p-8">
        <Text className="text-3xl font-bold text-white">Panel A</Text>
      </View>
      <View className="rounded-2xl bg-purple-600 p-8">
        <Text className="text-3xl font-bold text-white">Panel B</Text>
      </View>
    </View>
  );
};
```

### Scaling Typography by Resolution

Scale text sizes based on video resolution to maintain readability across formats.

```tsx
import { useVideoConfig } from "remotion";
import { View, Text } from "react-native";

export const ScaledText: React.FC = () => {
  const { width } = useVideoConfig();
  const isHighRes = width >= 3840; // 4K
  const isMidRes = width >= 1920;  // 1080p

  const titleClass = isHighRes
    ? "text-9xl"
    : isMidRes
    ? "text-7xl"
    : "text-4xl";

  return (
    <View className="flex-1 items-center justify-center bg-black">
      <Text className={`font-bold text-white ${titleClass}`}>
        Resolution-Aware Title
      </Text>
    </View>
  );
};
```

### Key Points

- Remotion compositions have fixed dimensions — there is no dynamic viewport.
- Use `useVideoConfig()` to read width/height and apply conditional classes.
- Common video resolutions: 1080p (1920x1080), 4K (3840x2160), vertical (1080x1920), square (1080x1080).
- Custom Tailwind breakpoints can be configured for video resolutions, but conditional classes via `useVideoConfig()` are often more practical.
- Container queries may be more useful than viewport breakpoints for video sub-layouts.
