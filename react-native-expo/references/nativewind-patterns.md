# NativeWind v4 — Complete Patterns

## 1. Installation & Setup

### Step-by-step with Expo SDK 52+

```bash
# 1. Install NativeWind and dependencies
npx expo install nativewind tailwindcss react-native-reanimated react-native-safe-area-context

# 2. Install dev dependencies
npm install -D tailwindcss@3.3.5 prettier-plugin-tailwindcss

# 3. Initialize Tailwind config
npx tailwindcss init
```

### metro.config.js
```js
const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require("nativewind/metro");

const config = getDefaultConfig(__dirname);

module.exports = withNativeWind(config, { input: "./global.css" });
```

### babel.config.js
```js
module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ["babel-preset-expo", { jsxImportSource: "nativewind" }],
      "nativewind/babel",
    ],
  };
};
```

### app/_layout.tsx — Import global.css
```typescript
import '../global.css';
import { Stack } from 'expo-router';

export default function RootLayout() {
  return <Stack screenOptions={{ headerShown: false }} />;
}
```

### nativewind-env.d.ts
```typescript
/// <reference types="nativewind/types" />
```

Add to `tsconfig.json`:
```json
{
  "include": ["**/*.ts", "**/*.tsx", "nativewind-env.d.ts"]
}
```

---

## 2. className Kullanım Kuralları

### ✅ Always use className for:
- Colors: `bg-background`, `text-foreground`, `border-border`
- Spacing: `px-4`, `py-6`, `mt-2`, `gap-4`
- Typography: `text-xl`, `font-bold`, `tracking-tight`
- Layout: `flex-1`, `flex-row`, `items-center`, `justify-between`
- Borders: `rounded-lg`, `border`, `border-hairline`
- Dimensions: `w-full`, `h-12`, `min-h-screen`

### ⚠️ Use style={{}} ONLY for:
- Dynamic/computed values: `style={{ height: scrollY * 0.5 }}`
- Animated styles from Reanimated: `style={animatedStyle}`
- Values from JavaScript variables that change at runtime

```typescript
// ✅ Static styling — className
<View className="flex-1 bg-background px-4 py-6">
  <Text className="text-2xl font-bold text-foreground">Hello</Text>
</View>

// ✅ Dynamic value — style
interface Props {
  progress: number;
}
const ProgressBar: React.FC<Props> = ({ progress }) => (
  <View className="h-2 bg-muted rounded-full overflow-hidden">
    <View className="h-full bg-primary rounded-full" style={{ width: `${progress}%` }} />
  </View>
);

// ❌ NEVER mix StyleSheet with className
// Don't do: <View className="flex-1" style={styles.container}>
```

---

## 3. Dark Mode

### CSS Variable Approach (Recommended)
Dark mode is handled via CSS variables in `global.css`. When the root element has `dark` class, variables automatically switch.

### useColorScheme Hook
```typescript
import { useColorScheme } from 'react-native';
// Or from NativeWind:
import { useColorScheme } from 'nativewind';

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const { colorScheme, setColorScheme, toggleColorScheme } = useColorScheme();

  return (
    <View className={`flex-1 ${colorScheme === 'dark' ? 'dark' : ''}`}>
      {children}
    </View>
  );
}
```

### Dark mode classes
```typescript
<View className="bg-white dark:bg-gray-950">
  <Text className="text-gray-900 dark:text-gray-100">
    Adapts to theme
  </Text>
  <View className="border-gray-200 dark:border-gray-800 border rounded-lg p-4">
    <Text className="text-muted-foreground">Semantic colors auto-switch</Text>
  </View>
</View>
```

### Toggle Button
```typescript
import { useColorScheme } from 'nativewind';
import { Pressable } from 'react-native';
import { Sun, Moon } from 'lucide-react-native';

export function ThemeToggle() {
  const { colorScheme, toggleColorScheme } = useColorScheme();
  return (
    <Pressable onPress={toggleColorScheme} className="p-2">
      {colorScheme === 'dark' ? (
        <Sun className="text-foreground" size={24} />
      ) : (
        <Moon className="text-foreground" size={24} />
      )}
    </Pressable>
  );
}
```

---

## 4. States & Pseudo-classes

```typescript
// Active state (on press)
<Pressable className="bg-primary active:bg-primary/80 rounded-lg p-4">
  <Text className="text-primary-foreground">Press me</Text>
</Pressable>

// Disabled state
<Pressable disabled={isDisabled} className="bg-primary disabled:opacity-50 rounded-lg p-4">
  <Text className="text-primary-foreground">Submit</Text>
</Pressable>

// Focus state (TextInput)
<TextInput className="border border-input focus:border-primary focus:ring-2 rounded-lg px-3 py-2" />

// Hover (web only)
<Pressable className="hover:bg-accent rounded-lg p-2">
  <Text>Hover me</Text>
</Pressable>

// Group states — parent controls child styling
<Pressable className="group flex-row items-center gap-3 p-3 rounded-lg active:bg-accent">
  <View className="w-10 h-10 rounded-full bg-primary group-active:bg-primary/80" />
  <Text className="text-foreground group-active:text-accent-foreground">Item</Text>
</Pressable>
```

---

## 5. Platform Selectors

```typescript
// Platform-specific padding
<View className="ios:pt-14 android:pt-8 web:pt-4">
  <Text>Platform-aware padding</Text>
</View>

// Platform-specific shadows
<View className="ios:shadow-lg android:elevation-4 bg-card rounded-xl p-4">
  <Text>Card with platform shadows</Text>
</View>

// Safe area (iOS specific)
<View className="ios:pb-safe">
  <Text>Bottom safe area on iOS</Text>
</View>

// Conditional rendering by platform
import { Platform } from 'react-native';
<View className={cn(
  "p-4",
  Platform.OS === 'ios' && "pt-safe",
  Platform.OS === 'android' && "pt-8"
)}>
```

---

## 6. Responsive Design

NativeWind supports Tailwind breakpoints based on window width:

```typescript
// Breakpoints: sm(640) md(768) lg(1024) xl(1280) 2xl(1536)

// Single column on mobile, 2 columns on tablet
<View className="flex-1 flex-col md:flex-row md:flex-wrap gap-4 px-4">
  <View className="w-full md:w-[48%]">
    <Card><CardContent><Text>Card 1</Text></CardContent></Card>
  </View>
  <View className="w-full md:w-[48%]">
    <Card><CardContent><Text>Card 2</Text></CardContent></Card>
  </View>
</View>

// Hide/show based on screen size
<View className="hidden md:flex">
  <Text>Only visible on tablet+</Text>
</View>

// Font size responsive
<Text className="text-lg md:text-2xl lg:text-4xl font-bold">
  Responsive Title
</Text>
```

---

## 7. CSS Variables & Theming

### Full theme setup in tailwind.config.js
See SKILL.md Core Setup section for the complete `tailwind.config.js` and `global.css`.

### Using semantic colors
```typescript
// These colors auto-switch between light/dark mode
<View className="bg-background">           {/* White / Dark navy */}
  <Text className="text-foreground">        {/* Dark text / Light text */}
  <Text className="text-muted-foreground">  {/* Gray text */}
  <View className="bg-card border-border">  {/* Card background + border */}
  <View className="bg-primary">             {/* Brand blue */}
  <Text className="text-primary-foreground"> {/* White on brand */}
  <View className="bg-destructive">         {/* Red */}
  <View className="bg-muted">              {/* Light gray / Dark gray */}
  <View className="bg-accent">             {/* Hover/active background */}
</View>
```

### Adding custom colors
```js
// tailwind.config.js → theme.extend.colors
colors: {
  // ...existing semantic colors...
  success: {
    DEFAULT: "hsl(var(--success))",
    foreground: "hsl(var(--success-foreground))",
  },
  warning: {
    DEFAULT: "hsl(var(--warning))",
    foreground: "hsl(var(--warning-foreground))",
  },
}
```

Then add CSS variables to `global.css`:
```css
:root {
  --success: 142 76% 36%;
  --success-foreground: 0 0% 100%;
  --warning: 38 92% 50%;
  --warning-foreground: 0 0% 100%;
}
```

---

## 8. Typography

```typescript
// Font sizes
<Text className="text-xs">12px — Caption</Text>
<Text className="text-sm">14px — Small body</Text>
<Text className="text-base">16px — Body (default)</Text>
<Text className="text-lg">18px — Large body</Text>
<Text className="text-xl">20px — Subtitle</Text>
<Text className="text-2xl">24px — Title</Text>
<Text className="text-3xl">30px — Large title</Text>
<Text className="text-4xl">36px — Display</Text>

// Font weights
<Text className="font-light">Light (300)</Text>
<Text className="font-normal">Normal (400)</Text>
<Text className="font-medium">Medium (500)</Text>
<Text className="font-semibold">Semibold (600)</Text>
<Text className="font-bold">Bold (700)</Text>
<Text className="font-extrabold">Extrabold (800)</Text>

// Letter spacing
<Text className="tracking-tighter">Tighter</Text>
<Text className="tracking-tight">Tight</Text>
<Text className="tracking-normal">Normal</Text>
<Text className="tracking-wide">Wide</Text>

// Line height
<Text className="leading-none">1.0</Text>
<Text className="leading-tight">1.25</Text>
<Text className="leading-normal">1.5</Text>
<Text className="leading-relaxed">1.625</Text>

// Combined typography pattern
<Text className="text-2xl font-bold tracking-tight text-foreground">
  Page Title
</Text>
<Text className="text-sm text-muted-foreground leading-relaxed">
  Description text that might wrap to multiple lines
</Text>
```

### Custom Fonts
```typescript
// app/_layout.tsx
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded] = useFonts({
    'Inter-Regular': require('../assets/fonts/Inter-Regular.ttf'),
    'Inter-Medium': require('../assets/fonts/Inter-Medium.ttf'),
    'Inter-Bold': require('../assets/fonts/Inter-Bold.ttf'),
  });

  useEffect(() => {
    if (loaded) SplashScreen.hideAsync();
  }, [loaded]);

  if (!loaded) return null;

  return <Stack />;
}
```

Add to `tailwind.config.js`:
```js
theme: {
  extend: {
    fontFamily: {
      sans: ['Inter-Regular'],
      medium: ['Inter-Medium'],
      bold: ['Inter-Bold'],
    },
  },
}
```

---

## 9. Spacing System

NativeWind uses Tailwind's 4px base spacing:

```
0  → 0px     1  → 4px     2  → 8px     3  → 12px
4  → 16px    5  → 20px    6  → 24px    8  → 32px
10 → 40px    12 → 48px    16 → 64px    20 → 80px
```

```typescript
// Padding
<View className="p-4">          {/* 16px all sides */}
<View className="px-4 py-6">    {/* 16px horizontal, 24px vertical */}
<View className="pt-2 pb-4">    {/* 8px top, 16px bottom */}
<View className="pl-3 pr-3">    {/* 12px left/right */}

// Margin
<View className="m-4">          {/* 16px all sides */}
<View className="mx-auto">      {/* Center horizontally */}
<View className="mt-6 mb-2">    {/* 24px top, 8px bottom */}
<View className="-mt-2">        {/* Negative margin */}

// Gap (Flexbox gap — preferred over margin between siblings)
<View className="flex-row gap-2">  {/* 8px between items */}
<View className="gap-4">          {/* 16px vertical gap */}
<View className="gap-x-2 gap-y-4"> {/* Different x/y gaps */}

// Space between (alternative to gap)
<View className="space-y-4">
  <Text>Item 1</Text>
  <Text>Item 2</Text>   {/* 16px between each */}
  <Text>Item 3</Text>
</View>
```

---

## 10. Animation with NativeWind

NativeWind supports transition utilities on web. On native, use Reanimated for animations.

```typescript
// Web transitions (only work on web platform)
<View className="web:transition-all web:duration-200 web:ease-in-out">
  <Text>Smooth on web</Text>
</View>

// For native animations, combine NativeWind className with Reanimated:
import Animated, { useAnimatedStyle, withSpring, useSharedValue } from 'react-native-reanimated';

function AnimatedCard() {
  const scale = useSharedValue(1);
  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  return (
    <Animated.View
      className="bg-card border border-border rounded-xl p-4"
      style={animatedStyle}
    >
      <Text className="text-card-foreground">Animated + NativeWind</Text>
    </Animated.View>
  );
}
```

---

## 11. Custom Utilities

### Extending tailwind.config.js

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      // Custom spacing
      spacing: {
        '18': '72px',
        '88': '352px',
        'safe-top': 'var(--safe-area-inset-top)',
      },
      // Custom border radius
      borderRadius: {
        '4xl': '2rem',
      },
      // Custom opacity
      opacity: {
        '15': '0.15',
      },
      // Custom z-index
      zIndex: {
        '60': '60',
        '70': '70',
      },
    },
  },
};
```

Usage:
```typescript
<View className="p-18 rounded-4xl z-60">
  <Text className="opacity-15">Custom utilities</Text>
</View>
```

---

## 12. cn() Pattern

### Setup
```bash
npm install clsx tailwind-merge
```

### lib/utils.ts
```typescript
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### Usage patterns

```typescript
import { cn } from '~/lib/utils';

// Conditional classes
interface Props {
  isActive: boolean;
  variant: 'primary' | 'secondary';
  className?: string;
}

function MyButton({ isActive, variant, className }: Props) {
  return (
    <Pressable
      className={cn(
        // Base styles
        "px-4 py-2 rounded-lg",
        // Variant styles
        variant === 'primary' && "bg-primary",
        variant === 'secondary' && "bg-secondary",
        // State styles
        isActive && "ring-2 ring-ring",
        !isActive && "opacity-70",
        // Allow consumer override
        className
      )}
    >
      <Text className={cn(
        "font-medium",
        variant === 'primary' && "text-primary-foreground",
        variant === 'secondary' && "text-secondary-foreground",
      )}>
        Button
      </Text>
    </Pressable>
  );
}

// ✅ cn() merges conflicting classes correctly
cn("px-4 py-2", "px-6") // → "px-6 py-2" (not "px-4 py-2 px-6")
cn("text-red-500", "text-blue-500") // → "text-blue-500"
```

---

## 13. Common Mistakes

### ❌ Mixing StyleSheet.create with className
```typescript
// ❌ WRONG
const styles = StyleSheet.create({ container: { flex: 1, padding: 16 } });
<View style={styles.container} className="bg-background">

// ✅ CORRECT
<View className="flex-1 p-4 bg-background">
```

### ❌ String concatenation for classes
```typescript
// ❌ WRONG — breaks Tailwind merge
const cls = "px-4 " + (isActive ? "bg-primary" : "bg-secondary");

// ✅ CORRECT
const cls = cn("px-4", isActive ? "bg-primary" : "bg-secondary");
```

### ❌ Using hex colors in className
```typescript
// ❌ WRONG — hardcoded color
<Text className="text-[#333333]">

// ✅ CORRECT — semantic token
<Text className="text-foreground">
```

### ❌ Forgetting global.css import
```typescript
// ❌ If colors aren't working, check app/_layout.tsx has:
import '../global.css';
```

### ❌ Using NativeWind className on non-RN components
```typescript
// ❌ className won't work on custom components unless they forward it
<MyWrapper className="p-4"> // Does nothing unless MyWrapper accepts className

// ✅ Forward className in custom components
interface Props {
  className?: string;
  children: React.ReactNode;
}
function MyWrapper({ className, children }: Props) {
  return <View className={cn("default-styles", className)}>{children}</View>;
}
```

### ❌ Percentage widths without explicit parent dimensions
```typescript
// ❌ May not work on native
<View className="w-1/2"> // Needs parent with defined width

// ✅ Use flex instead
<View className="flex-1 flex-row">
  <View className="flex-1"><Text>Half</Text></View>
  <View className="flex-1"><Text>Half</Text></View>
</View>
```
