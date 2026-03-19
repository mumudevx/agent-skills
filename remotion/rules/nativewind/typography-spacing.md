---
name: typography-spacing
description: Text classes, spacing system, and gap utilities for video composition typography
metadata:
  tags: nativewind, remotion, typography, spacing, gap, text, font, leading, tracking
---

## Typography and Spacing for Video Compositions

Typography in video requires larger sizes and careful spacing for readability. NativeWind provides the full set of Tailwind text, font, spacing, and gap utilities that work with React Native components in Remotion compositions.

### Text Sizing for Video

For video content, prefer larger text sizes (`text-2xl` and above) to ensure readability. Standard web text sizes (`text-sm`, `text-base`) are too small for most video formats.

```tsx
import { View, Text } from "react-native";

export const TypographyScene: React.FC = () => {
  return (
    <View className="flex-1 justify-center gap-6 bg-slate-900 p-16">
      <Text className="text-7xl font-black tracking-tight text-white">
        Main Title
      </Text>
      <Text className="text-2xl font-light leading-relaxed text-slate-300">
        Subtitle with comfortable line height for video readability.
      </Text>
      <View className="flex-row gap-4">
        <Text className="text-lg font-medium text-blue-400">Tag One</Text>
        <Text className="text-lg font-medium text-green-400">Tag Two</Text>
      </View>
    </View>
  );
};
```

### Font Weight Classes

NativeWind supports the full range of font weight utilities:

- `font-thin` (100)
- `font-extralight` (200)
- `font-light` (300)
- `font-normal` (400)
- `font-medium` (500)
- `font-semibold` (600)
- `font-bold` (700)
- `font-extrabold` (800)
- `font-black` (900)

```tsx
import { View, Text } from "react-native";

export const FontWeightsDemo: React.FC = () => {
  return (
    <View className="flex-1 justify-center gap-3 bg-black p-16">
      <Text className="text-4xl font-thin text-white">Thin Weight</Text>
      <Text className="text-4xl font-light text-white">Light Weight</Text>
      <Text className="text-4xl font-normal text-white">Normal Weight</Text>
      <Text className="text-4xl font-bold text-white">Bold Weight</Text>
      <Text className="text-4xl font-black text-white">Black Weight</Text>
    </View>
  );
};
```

### Line Height and Letter Spacing

Use `leading-*` classes for line height and `tracking-*` classes for letter spacing. These are critical for long-form text readability in video.

```tsx
import { View, Text } from "react-native";

export const TextSpacingScene: React.FC = () => {
  return (
    <View className="flex-1 justify-center gap-10 bg-slate-950 p-20">
      <Text className="text-3xl font-bold leading-tight tracking-tight text-white">
        Tight leading and tracking for headlines that need compact spacing
      </Text>
      <Text className="text-xl font-normal leading-relaxed tracking-wide text-slate-300">
        Relaxed leading and wide tracking for body text that needs breathing
        room and comfortable reading in video format.
      </Text>
    </View>
  );
};
```

### Spacing and Gap Utilities

Use `p-*`, `m-*`, and `gap-*` utilities for spacing. In video compositions, generous spacing improves visual hierarchy.

```tsx
import { View, Text } from "react-native";

export const SpacingScene: React.FC = () => {
  return (
    <View className="flex-1 bg-gray-950 p-16">
      {/* gap for consistent child spacing */}
      <View className="gap-8">
        <Text className="text-5xl font-bold text-white">Section Title</Text>
        <Text className="text-xl text-gray-400">Section description</Text>
      </View>

      {/* margin for individual element spacing */}
      <View className="mt-16 rounded-2xl bg-gray-800 p-10">
        <Text className="text-2xl font-semibold text-white">Card Title</Text>
        <Text className="mt-4 text-lg text-gray-300">
          Card content with margin-top spacing.
        </Text>
      </View>

      {/* flex-row with gap */}
      <View className="mt-12 flex-row gap-6">
        <View className="flex-1 rounded-xl bg-blue-600 p-6">
          <Text className="text-center text-lg font-medium text-white">Column A</Text>
        </View>
        <View className="flex-1 rounded-xl bg-purple-600 p-6">
          <Text className="text-center text-lg font-medium text-white">Column B</Text>
        </View>
      </View>
    </View>
  );
};
```

### Text Alignment

Use `text-left`, `text-center`, and `text-right` for horizontal text alignment within video frames.

```tsx
import { View, Text } from "react-native";

export const AlignmentScene: React.FC = () => {
  return (
    <View className="flex-1 justify-center gap-8 bg-black p-16">
      <Text className="text-3xl font-bold text-left text-white">
        Left Aligned
      </Text>
      <Text className="text-3xl font-bold text-center text-white">
        Center Aligned
      </Text>
      <Text className="text-3xl font-bold text-right text-white">
        Right Aligned
      </Text>
    </View>
  );
};
```

### Key Points

- Use `text-2xl` and above for video readability — standard web sizes are too small.
- `leading-*` (line height) and `tracking-*` (letter spacing) are critical for video text.
- `gap-*` is preferred over margin for consistent spacing between sibling elements.
- `p-*` utilities provide padding — use generous padding (`p-8`+) for video compositions.
- Font weight ranges from `font-thin` (100) to `font-black` (900).
- Text alignment with `text-left`, `text-center`, `text-right`.
