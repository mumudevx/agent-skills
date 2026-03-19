---
name: borders-shadows
description: Border, rounded, shadow utilities for video element visual effects
metadata:
  tags: nativewind, remotion, borders, shadows, rounded, opacity, ring, visual-effects
---

## Borders, Shadows, and Visual Effects for Video Elements

NativeWind provides border, rounded corner, shadow, opacity, and ring utilities that work with React Native in Remotion compositions. Note that shadow handling differs between native and web — NativeWind translates between the two systems.

### Border Utilities

Use `border`, `border-2`, `border-4`, `border-8` for border widths combined with color classes.

```tsx
import { View, Text } from "react-native";

export const CardElement: React.FC = () => {
  return (
    <View className="flex-1 items-center justify-center bg-slate-900">
      <View className="rounded-3xl border-2 border-white/10 bg-white/5 p-10 shadow-2xl">
        <Text className="text-3xl font-bold text-white">Glass Card</Text>
        <Text className="mt-2 text-lg text-slate-300">
          With border and shadow effects
        </Text>
      </View>

      <View className="mt-8 rounded-full border-4 border-blue-500 p-6">
        <Text className="text-xl font-semibold text-blue-400">Badge</Text>
      </View>
    </View>
  );
};
```

### Rounded Corners

NativeWind supports the full range of border radius utilities:

- `rounded-sm` (2px), `rounded` (4px), `rounded-md` (6px), `rounded-lg` (8px)
- `rounded-xl` (12px), `rounded-2xl` (16px), `rounded-3xl` (24px)
- `rounded-full` (9999px — creates circles/pills)

```tsx
import { View, Text } from "react-native";

export const RoundedDemo: React.FC = () => {
  return (
    <View className="flex-1 flex-row items-center justify-center gap-8 bg-black">
      <View className="rounded bg-blue-500 p-6">
        <Text className="text-white">rounded</Text>
      </View>
      <View className="rounded-xl bg-green-500 p-6">
        <Text className="text-white">rounded-xl</Text>
      </View>
      <View className="rounded-3xl bg-purple-500 p-6">
        <Text className="text-white">rounded-3xl</Text>
      </View>
      <View className="h-24 w-24 items-center justify-center rounded-full bg-red-500">
        <Text className="text-white">full</Text>
      </View>
    </View>
  );
};
```

### Shadow Utilities

React Native shadows differ from web CSS shadows. NativeWind handles the translation:

- On native: `shadowColor`, `shadowOffset`, `shadowOpacity`, `shadowRadius`
- On web (Remotion renders to web): standard CSS `box-shadow`

```tsx
import { View, Text } from "react-native";

export const ShadowDemo: React.FC = () => {
  return (
    <View className="flex-1 items-center justify-center gap-8 bg-slate-950">
      <View className="rounded-2xl bg-slate-800 p-8 shadow-md">
        <Text className="text-xl text-white">Medium Shadow</Text>
      </View>
      <View className="rounded-2xl bg-slate-800 p-8 shadow-xl">
        <Text className="text-xl text-white">XL Shadow</Text>
      </View>
      <View className="rounded-2xl bg-slate-800 p-8 shadow-2xl">
        <Text className="text-xl text-white">2XL Shadow</Text>
      </View>
    </View>
  );
};
```

### Opacity Utilities

Use `opacity-*` classes for static opacity values. For animated opacity in video, combine with Remotion's `useCurrentFrame()` via the `style` prop.

```tsx
import { useCurrentFrame, interpolate } from "remotion";
import { View, Text } from "react-native";

export const OpacityScene: React.FC = () => {
  const frame = useCurrentFrame();
  const animatedOpacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <View className="flex-1 items-center justify-center gap-6 bg-black">
      {/* Static opacity */}
      <Text className="text-2xl text-white opacity-100">Full Opacity</Text>
      <Text className="text-2xl text-white opacity-50">Half Opacity</Text>
      <Text className="text-2xl text-white opacity-25">Quarter Opacity</Text>

      {/* Animated opacity via style */}
      <Text className="text-2xl text-blue-400" style={{ opacity: animatedOpacity }}>
        Animated Opacity
      </Text>
    </View>
  );
};
```

### Border Color with Alpha

Use the `/` syntax for border color opacity, useful for glass-morphism and subtle dividers in video.

```tsx
import { View, Text } from "react-native";

export const BorderAlphaScene: React.FC = () => {
  return (
    <View className="flex-1 items-center justify-center bg-slate-900">
      <View className="rounded-2xl border border-white/20 bg-white/10 p-10">
        <Text className="text-2xl font-bold text-white">Glass Panel</Text>
      </View>
      <View className="mt-6 rounded-xl border-2 border-blue-400/50 p-6">
        <Text className="text-lg text-blue-300">Subtle Border</Text>
      </View>
    </View>
  );
};
```

### Ring Utilities

Ring utilities create outline-like effects around elements, useful for highlighting or focus indicators in video UI mockups.

```tsx
import { View, Text } from "react-native";

export const RingDemo: React.FC = () => {
  return (
    <View className="flex-1 items-center justify-center gap-8 bg-gray-950">
      <View className="rounded-xl bg-gray-800 p-6 ring-2 ring-blue-500">
        <Text className="text-xl text-white">Blue Ring</Text>
      </View>
      <View className="rounded-xl bg-gray-800 p-6 ring-4 ring-green-400/50">
        <Text className="text-xl text-white">Green Ring with Alpha</Text>
      </View>
    </View>
  );
};
```

### Key Points

- Border width: `border`, `border-2`, `border-4`, `border-8` with color classes.
- Rounded corners: `rounded-sm` through `rounded-full`.
- Shadows translate differently on native vs. web — Remotion renders to web, so CSS box-shadow applies.
- Use `/` syntax for alpha values on border and background colors (e.g., `border-white/10`).
- Static opacity via `opacity-*` classes; animated opacity via `style` prop with Remotion.
- Ring utilities provide outline-like effects for element highlighting.
