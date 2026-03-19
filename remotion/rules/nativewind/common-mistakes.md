---
name: common-mistakes
description: StyleSheet + className mixing, hex color issues, and className forwarding errors
metadata:
  tags: nativewind, remotion, mistakes, debugging, common-errors, best-practices
---

## Common NativeWind Mistakes in Remotion Compositions

Avoid these frequent pitfalls when using NativeWind with Remotion. The core rule is: use `className` for static styling and `style` for Remotion-driven dynamic values. Never mix them for the same CSS property.

### Mixing className and style for the Same Property

When both `className` and `style` set the same property, the result is unpredictable. Keep static layout in `className` and animated/dynamic values in `style`.

```tsx
// WRONG: Mixing className and style for the same property
<View className="bg-red-500" style={{ backgroundColor: "blue" }}>
  {/* backgroundColor conflict — unpredictable result */}
</View>

// CORRECT: className for static, style for dynamic (Remotion-driven)
<View className="rounded-xl p-8" style={{ opacity, transform: [{ scale }] }}>
  {/* className handles layout, style handles animation */}
</View>
```

### Using Tailwind Animations Instead of Remotion

Tailwind's `animate-*` and `transition-*` classes rely on CSS animations and transitions, which do not integrate with Remotion's frame-based rendering. Always use `useCurrentFrame()` and `interpolate()` for animations.

```tsx
import { useCurrentFrame, interpolate } from "remotion";
import { View, Text } from "react-native";

// WRONG: Using Tailwind animations in Remotion
export const WrongAnimation: React.FC = () => {
  return (
    <View className="animate-bounce">
      <Text className="transition-opacity duration-300">Fading</Text>
    </View>
  );
};

// CORRECT: Use Remotion's animation system
export const CorrectAnimation: React.FC = () => {
  const frame = useCurrentFrame();
  const opacity = interpolate(frame, [0, 30], [0, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <View style={{ opacity }}>
      <Text className="text-2xl text-white">Fading</Text>
    </View>
  );
};
```

### Incorrect Arbitrary Hex Colors

When using arbitrary hex colors in Tailwind, the value must be wrapped in square brackets. Omitting brackets causes the class to be ignored.

```tsx
// WRONG: Missing brackets for hex color
<View className="bg-ff0000" />

// CORRECT: Arbitrary hex color with brackets
<View className="bg-[#ff0000]" />

// ALSO CORRECT: Use Tailwind's built-in color palette
<View className="bg-red-500" />
```

### Forgetting to Import global.css

Without the global CSS import at the app entry point, no NativeWind styles will apply. This is one of the most common setup issues.

```tsx
// WRONG: Missing global.css import — no styles render
// App.tsx
export default function App() {
  return <MyComposition />;
}

// CORRECT: Import global.css at the entry point
// App.tsx
import "./global.css";

export default function App() {
  return <MyComposition />;
}
```

### className on Third-Party Components

Third-party components that don't forward the `className` prop will silently ignore NativeWind styles. Use `remapProps` to fix this or wrap the component.

```tsx
import { remapProps } from "nativewind";
import { View } from "react-native";
import { ThirdPartyCard } from "some-library";

// WRONG: className on third-party component that picks props
// The component might not forward className
<ThirdPartyCard className="bg-blue-500 p-4" />

// CORRECT: Use remapProps to map className to style
remapProps(ThirdPartyCard, { className: "style" });
<ThirdPartyCard className="bg-blue-500 p-4" />

// ALTERNATIVE: Wrap with a View
<View className="bg-blue-500 p-4">
  <ThirdPartyCard />
</View>
```

### Dynamic Template Literals for Class Names

Tailwind classes must be statically analyzable. Constructing class names dynamically with template literals won't work because Tailwind cannot detect them at build time.

```tsx
import { useCurrentFrame } from "remotion";
import { View } from "react-native";

// WRONG: Dynamic class name via template literal
const frame = useCurrentFrame();
<View className={`text-${frame > 30 ? "blue" : "red"}-500`} />
// Tailwind won't generate "text-blue-500" or "text-red-500"

// CORRECT: Use complete class names in conditionals
<View className={frame > 30 ? "text-blue-500" : "text-red-500"} />
```

### Summary of Rules

| Pattern | Status | Reason |
|---|---|---|
| `className` for static layout | Correct | NativeWind transforms at build time |
| `style` for Remotion-driven values | Correct | Dynamic values need runtime evaluation |
| Mixing same property in both | Wrong | Unpredictable override behavior |
| Tailwind `animate-*` / `transition-*` | Wrong | Does not integrate with Remotion frames |
| Arbitrary hex without brackets | Wrong | Tailwind ignores the class |
| Missing `global.css` import | Wrong | No styles render at all |
| `className` on third-party components | Wrong | May not forward the prop |
| Dynamic template literal class names | Wrong | Not statically analyzable |
