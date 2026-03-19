---
name: classname-patterns
description: className prop usage, cn() helper, and conditional classes in Remotion components
metadata:
  tags: nativewind, remotion, classname, cn, conditional, dynamic, useCurrentFrame
---

## className Patterns in Remotion Compositions

NativeWind transforms the `className` prop on React Native components into the corresponding `style` prop at build time. Within Remotion compositions, static classes work directly, but dynamic (frame-driven) values must use the `style` prop.

### Basic className Usage

Use the `className` prop on React Native components (`View`, `Text`, `Image`, etc.) with Tailwind utility classes.

```tsx
import { useCurrentFrame, interpolate } from "remotion";
import { View, Text } from "react-native";

export const StyledScene: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <View className="flex-1 items-center justify-center bg-slate-900">
      {/* Static classes work perfectly */}
      <Text className="text-4xl font-bold text-white">Title</Text>

      {/* Dynamic values via style prop */}
      <View className="rounded-2xl bg-blue-500 p-8" style={{ opacity }}>
        <Text className="text-lg text-white">Fading Content</Text>
      </View>
    </View>
  );
};
```

### cn() Helper for Conditional Classes

Use a `cn()` helper built from `clsx` and `tailwind-merge` to conditionally apply classes. This is especially useful for toggling styles based on frame ranges.

```tsx
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

```tsx
import { useCurrentFrame } from "remotion";
import { View, Text } from "react-native";
import { cn } from "../utils/cn";

export const ConditionalScene: React.FC = () => {
  const frame = useCurrentFrame();
  const isVisible = frame >= 20;
  const isHighlighted = frame >= 40;

  return (
    <View className="flex-1 items-center justify-center bg-gray-950">
      <Text
        className={cn(
          "text-5xl font-bold",
          isVisible ? "text-white" : "text-transparent",
          isHighlighted && "text-yellow-400"
        )}
      >
        Conditional Text
      </Text>
    </View>
  );
};
```

### Dynamic Values — Use style, Not Template Literals

Template literals for frame-based dynamic values do NOT work with NativeWind because Tailwind classes must be statically analyzable. Always use the `style` prop for values computed from `useCurrentFrame()`.

```tsx
import { useCurrentFrame, interpolate } from "remotion";
import { View } from "react-native";

export const DynamicExample: React.FC = () => {
  const frame = useCurrentFrame();
  const translateY = interpolate(frame, [0, 30], [50, 0], {
    extrapolateRight: "clamp",
  });

  return (
    // WRONG: `translate-y-[${translateY}px]` — will not work
    // CORRECT: use style for dynamic values
    <View
      className="h-40 w-40 rounded-xl bg-blue-500"
      style={{ transform: [{ translateY }] }}
    />
  );
};
```

### Key Points

- NativeWind transforms `className` to `style` at build time.
- Use `cn()` (clsx + tailwind-merge) for conditional class composition.
- Static classes on `className`, dynamic values on `style` — never mix purposes.
- Template literal interpolation for dynamic Tailwind values does not work.
