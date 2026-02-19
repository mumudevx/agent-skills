---
name: react-native-expo
description: Expert React Native development with Expo Router, NativeWind v4, and React Native Reusables (shadcn/ui for RN). Use when building mobile apps, screens, components, or navigation with this stack.
---

# React Native + Expo Skill

## When to Use This Skill
- Building React Native screens or components
- Setting up navigation with Expo Router
- Styling with NativeWind (className based Tailwind)
- Adding UI components from React Native Reusables
- Implementing dark mode / theming
- Animations with Reanimated 3
- Gesture-driven interactions
- Performance optimization

## Stack Overview
```
Expo Router v4       → File-based navigation (app/ directory)
NativeWind v4        → Tailwind CSS via className prop
React Native Reusables → Pre-built UI components (shadcn/ui port)
Reanimated 3         → 60fps animations on UI thread
Gesture Handler 2    → Pan, pinch, tap gestures
TypeScript           → Required for all components
```

## Project Structure (Standard)
```
my-app/
├── app/
│   ├── _layout.tsx          ← Root layout (fonts, providers, theme)
│   ├── index.tsx            ← Entry/splash screen
│   ├── (auth)/
│   │   ├── _layout.tsx
│   │   ├── login.tsx
│   │   └── register.tsx
│   └── (tabs)/
│       ├── _layout.tsx      ← Tab bar definition
│       ├── index.tsx        ← Home tab
│       ├── search.tsx
│       └── profile.tsx
├── components/
│   ├── ui/                  ← RNR components live here
│   │   ├── button.tsx
│   │   ├── dialog.tsx
│   │   └── ...
│   └── [feature-name]/      ← Feature-specific components
├── lib/
│   └── utils.ts             ← cn() helper and utilities
├── constants/
│   └── colors.ts            ← Design tokens
├── global.css               ← Tailwind directives
├── tailwind.config.js
└── nativewind-env.d.ts
```

## Core Setup

### tailwind.config.js (with design tokens + dark mode via CSS vars)
```js
const { hairlineWidth } = require("nativewind/theme");

/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: ["./app/**/*.{js,jsx,ts,tsx}", "./components/**/*.{js,jsx,ts,tsx}"],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderWidth: {
        hairline: hairlineWidth(),
      },
    },
  },
  plugins: [],
};
```

### global.css (CSS variables for light + dark theme)
```css
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --card: 0 0% 100%;
    --card-foreground: 222.2 84% 4.9%;
    --primary: 221.2 83.2% 53.3%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96.1%;
    --secondary-foreground: 222.2 47.4% 11.2%;
    --muted: 210 40% 96.1%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --accent: 210 40% 96.1%;
    --accent-foreground: 222.2 47.4% 11.2%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 210 40% 98%;
    --border: 214.3 31.8% 91.4%;
    --input: 214.3 31.8% 91.4%;
    --ring: 221.2 83.2% 53.3%;
  }
  .dark:root {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --card: 222.2 84% 4.9%;
    --card-foreground: 210 40% 98%;
    --primary: 217.2 91.2% 59.8%;
    --primary-foreground: 222.2 47.4% 11.2%;
    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    --accent: 217.2 32.6% 17.5%;
    --accent-foreground: 210 40% 98%;
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 224.3 76.3% 48%;
  }
}
```

### nativewind-env.d.ts
```typescript
/// <reference types="nativewind/types" />
```

### lib/utils.ts
```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

## NativeWind v4 — Key Rules

1. **NEVER use `StyleSheet.create`** for colors or spacing — use `className`
2. **Dark mode** via `dark:` prefix: `className="bg-white dark:bg-gray-900"`
3. **Platform selectors**: `className="ios:pt-safe android:pt-0"`
4. **States**: `active:opacity-80`, `disabled:opacity-50`, `focus:border-primary`
5. **Group states**: Add `group` to parent, use `group-active:scale-95` on children
6. **Conditional classes**: Use `cn()` helper, never string concatenation
7. **Inline style only for**: dynamic values that can't be expressed as Tailwind classes (e.g., `style={{ height: dynamicHeight }}`)

```typescript
// ✅ Correct
<View className="flex-1 bg-background px-4 py-6">
  <Text className="text-foreground text-xl font-bold dark:text-white">Title</Text>
</View>

// ❌ Wrong — never do this
<View style={{ flex: 1, backgroundColor: '#fff', paddingHorizontal: 16 }}>
```

## React Native Reusables — Component Installation

```bash
# Setup (one-time)
npx @react-native-reusables/cli@latest init

# Add individual components
npx @react-native-reusables/cli@latest add button
npx @react-native-reusables/cli@latest add dialog
npx @react-native-reusables/cli@latest add bottom-sheet
npx @react-native-reusables/cli@latest add input
npx @react-native-reusables/cli@latest add card
npx @react-native-reusables/cli@latest add select
npx @react-native-reusables/cli@latest add avatar
npx @react-native-reusables/cli@latest add badge
npx @react-native-reusables/cli@latest add checkbox
npx @react-native-reusables/cli@latest add progress
npx @react-native-reusables/cli@latest add skeleton
npx @react-native-reusables/cli@latest add toast
npx @react-native-reusables/cli@latest add alert-dialog
npx @react-native-reusables/cli@latest add dropdown-menu
npx @react-native-reusables/cli@latest add label
npx @react-native-reusables/cli@latest add separator
npx @react-native-reusables/cli@latest add switch
npx @react-native-reusables/cli@latest add tabs
npx @react-native-reusables/cli@latest add tooltip
```

**shadcn MCP (alternative):** Add registry to `components.json`:
```json
{
  "registries": {
    "@rnr": "https://reactnativereusables.com/r/nativewind/{name}.json"
  }
}
```

## Quick Reference — RNR Components

```typescript
// Button
import { Button } from '~/components/ui/button';
<Button variant="default" size="lg" onPress={handlePress}>
  <Text>Submit</Text>
</Button>
// variants: default | destructive | outline | secondary | ghost | link
// sizes: default | sm | lg | icon

// Input
import { Input } from '~/components/ui/input';
<Input placeholder="Email" value={email} onChangeText={setEmail}
       keyboardType="email-address" className="mb-4" />

// Card
import { Card, CardHeader, CardTitle, CardContent } from '~/components/ui/card';
<Card className="mx-4">
  <CardHeader><CardTitle>Title</CardTitle></CardHeader>
  <CardContent><Text>Content</Text></CardContent>
</Card>

// Dialog (Modal)
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '~/components/ui/dialog';
<Dialog>
  <DialogTrigger asChild>
    <Button><Text>Open</Text></Button>
  </DialogTrigger>
  <DialogContent>
    <DialogHeader><DialogTitle>Dialog Title</DialogTitle></DialogHeader>
    <Text>Dialog content here</Text>
  </DialogContent>
</Dialog>

// Badge
import { Badge } from '~/components/ui/badge';
<Badge variant="secondary"><Text>New</Text></Badge>

// Avatar
import { Avatar, AvatarImage, AvatarFallback } from '~/components/ui/avatar';
<Avatar>
  <AvatarImage source={{ uri: user.avatar }} />
  <AvatarFallback><Text>JD</Text></AvatarFallback>
</Avatar>
```

## Expo Router — Navigation Patterns

```typescript
// Root _layout.tsx
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import '../global.css';

export default function RootLayout() {
  return (
    <>
      <StatusBar style="auto" />
      <Stack screenOptions={{ headerShown: false }}>
        <Stack.Screen name="(auth)" />
        <Stack.Screen name="(tabs)" />
      </Stack>
    </>
  );
}

// Tab layout: app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';
import { Home, Search, User } from 'lucide-react-native';

export default function TabLayout() {
  return (
    <Tabs screenOptions={{
      tabBarActiveTintColor: 'hsl(var(--primary))',
      tabBarShowLabel: false,
    }}>
      <Tabs.Screen name="index" options={{
        title: 'Home',
        tabBarIcon: ({ color, size }) => <Home color={color} size={size} />,
      }} />
      <Tabs.Screen name="search" options={{
        title: 'Search',
        tabBarIcon: ({ color, size }) => <Search color={color} size={size} />,
      }} />
    </Tabs>
  );
}

// Navigation
import { useRouter, Link } from 'expo-router';
const router = useRouter();
router.push('/profile/123');
router.replace('/(auth)/login');
router.back();

// Dynamic routes: app/profile/[id].tsx
import { useLocalSearchParams } from 'expo-router';
const { id } = useLocalSearchParams<{ id: string }>();
```

## Best Practices

1. **className over style**: Use NativeWind classes 100% for colors, spacing, typography. Reserve `style={{}}` only for dynamic/computed values.
2. **RNR first**: Before writing a custom component, check if RNR has it. Customization via `className` prop or editing the copied source.
3. **cn() for conditionals**: `className={cn("base-classes", isActive && "active-classes", variant === 'primary' && "primary-classes")}`
4. **Expo Router file conventions**: `[param].tsx` for dynamic, `(group)/` for logical groups, `+not-found.tsx` for 404.
5. **Safe areas**: Always wrap root with `<SafeAreaProvider>`, use `useSafeAreaInsets()` for custom padding.
6. **Dark mode toggle**: Use `useColorScheme()` from RNR or NativeWind. Set `className` on root View: `className={isDark ? 'dark' : ''}`.
7. **FlatList over ScrollView+map**: Never use `{items.map(...)}` inside ScrollView for lists of 10+ items.
8. **Performance**: `React.memo` for list items, `useCallback` for handlers passed to list items, `Reanimated` for 60fps.

## Common Patterns — Screen Template

```typescript
import { View, Text, ScrollView } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Button } from '~/components/ui/button';
import { Card, CardContent } from '~/components/ui/card';

export default function HomeScreen() {
  return (
    <SafeAreaView className="flex-1 bg-background">
      <ScrollView className="flex-1" contentContainerClassName="px-4 py-6 gap-4">

        <View className="flex-row items-center justify-between mb-2">
          <Text className="text-2xl font-bold text-foreground">Dashboard</Text>
          <Button variant="ghost" size="icon">
            <Text>⚙️</Text>
          </Button>
        </View>

        <Card>
          <CardContent className="pt-4">
            <Text className="text-muted-foreground text-sm">Revenue</Text>
            <Text className="text-3xl font-bold text-foreground mt-1">$12,480</Text>
          </CardContent>
        </Card>

      </ScrollView>
    </SafeAreaView>
  );
}
```

## References
- See `references/nativewind-patterns.md` — NativeWind v4 complete patterns
- See `references/rnr-components.md` — All RNR component APIs
- See `references/expo-router-patterns.md` — Navigation patterns
- See `references/reanimated-patterns.md` — Animation patterns
- See `references/styling-patterns.md` — Theming, dark mode, responsive
