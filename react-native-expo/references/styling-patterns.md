# Styling Patterns — NativeWind v4

## 1. Design Token System

All colors are defined as CSS variables in `global.css` and mapped in `tailwind.config.js`:

```
Semantic Token       Light                    Dark
─────────────────────────────────────────────────────
background           White (#fff)             Dark navy (#030712)
foreground           Dark text (#0a0f1a)      Light text (#f8fafc)
card                 White                    Dark navy
primary              Blue (#3b82f6)           Light blue (#60a5fa)
secondary            Light gray (#f1f5f9)     Dark gray (#1e293b)
muted                Light gray               Dark gray
accent               Light gray               Dark gray
destructive          Red (#ef4444)            Dark red (#7f1d1d)
border               Light border (#e2e8f0)   Dark border (#1e293b)
```

### Usage — always semantic tokens
```typescript
// ✅ Use semantic colors
<View className="bg-background">
  <Text className="text-foreground">Main text</Text>
  <Text className="text-muted-foreground">Secondary text</Text>
  <View className="bg-card border border-border rounded-lg p-4">
    <Text className="text-card-foreground">Card text</Text>
  </View>
</View>

// ❌ Never hardcode colors
<View className="bg-white">        {/* Won't adapt to dark mode */}
<Text className="text-[#333]">     {/* Hardcoded hex */}
```

---

## 2. Dark Mode Implementation

### ThemeProvider pattern
```typescript
// lib/theme.tsx
import { useColorScheme as useNativeWindColorScheme } from 'nativewind';
import { createContext, useContext } from 'react';

type Theme = 'light' | 'dark' | 'system';

interface ThemeContextType {
  theme: Theme;
  isDark: boolean;
  setTheme: (theme: Theme) => void;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const { colorScheme, setColorScheme, toggleColorScheme } = useNativeWindColorScheme();

  return (
    <ThemeContext.Provider value={{
      theme: colorScheme ?? 'light',
      isDark: colorScheme === 'dark',
      setTheme: setColorScheme,
      toggleTheme: toggleColorScheme,
    }}>
      {children}
    </ThemeContext.Provider>
  );
}

export const useTheme = () => {
  const ctx = useContext(ThemeContext);
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider');
  return ctx;
};
```

### Root layout setup
```typescript
// app/_layout.tsx
import '../global.css';
import { ThemeProvider } from '~/lib/theme';
import { Stack } from 'expo-router';

export default function RootLayout() {
  return (
    <ThemeProvider>
      <Stack screenOptions={{ headerShown: false }} />
    </ThemeProvider>
  );
}
```

### Dark mode toggle component
```typescript
import { useTheme } from '~/lib/theme';
import { Button } from '~/components/ui/button';
import { Sun, Moon } from 'lucide-react-native';

export function ThemeToggle() {
  const { isDark, toggleTheme } = useTheme();
  return (
    <Button variant="ghost" size="icon" onPress={toggleTheme}>
      {isDark ? (
        <Sun size={20} className="text-foreground" />
      ) : (
        <Moon size={20} className="text-foreground" />
      )}
    </Button>
  );
}
```

---

## 3. Typography Scale

```typescript
// Size scale
<Text className="text-xs">12px — fine print, badges</Text>
<Text className="text-sm">14px — captions, secondary text</Text>
<Text className="text-base">16px — body text (default)</Text>
<Text className="text-lg">18px — emphasized body</Text>
<Text className="text-xl">20px — section headers</Text>
<Text className="text-2xl">24px — page titles</Text>
<Text className="text-3xl">30px — large titles</Text>
<Text className="text-4xl">36px — hero text</Text>

// Weight classes
<Text className="font-normal">400 — body</Text>
<Text className="font-medium">500 — labels</Text>
<Text className="font-semibold">600 — emphasis</Text>
<Text className="font-bold">700 — titles</Text>

// Common typography patterns
<Text className="text-2xl font-bold text-foreground tracking-tight">Page Title</Text>
<Text className="text-lg font-semibold text-foreground">Section Header</Text>
<Text className="text-base text-foreground leading-relaxed">Body paragraph</Text>
<Text className="text-sm text-muted-foreground">Helper text</Text>
<Text className="text-xs text-muted-foreground uppercase tracking-wide">Label</Text>
```

---

## 4. Spacing System

```
Class    Value     Use case
──────────────────────────────────
gap-1    4px      Tight inline elements
gap-2    8px      Related items (icon + text)
gap-3    12px     List item spacing
gap-4    16px     Standard section gap
gap-6    24px     Major section separation
gap-8    32px     Page-level separation
px-4     16px     Standard horizontal padding
py-6     24px     Standard vertical padding
```

```typescript
// Screen layout
<SafeAreaView className="flex-1 bg-background">
  <ScrollView contentContainerClassName="px-4 py-6 gap-6">
    {/* Section 1 */}
    <View className="gap-2">
      <Text className="text-2xl font-bold text-foreground">Title</Text>
      <Text className="text-muted-foreground">Description</Text>
    </View>

    {/* Section 2 */}
    <View className="gap-4">
      <Card>...</Card>
      <Card>...</Card>
    </View>
  </ScrollView>
</SafeAreaView>

// Form layout
<View className="gap-4">
  <View className="gap-1.5">
    <Label>Email</Label>
    <Input placeholder="you@example.com" />
  </View>
  <View className="gap-1.5">
    <Label>Password</Label>
    <Input secureTextEntry />
  </View>
  <Button className="mt-2"><Text>Sign In</Text></Button>
</View>
```

---

## 5. Border & Shadow

```typescript
// Borders
<View className="border border-border rounded-lg">           {/* Standard */}
<View className="border-hairline border-border rounded-lg">  {/* 1px exactly */}
<View className="border-2 border-primary rounded-xl">        {/* Thick accent */}

// Border radius scale
<View className="rounded-sm">    {/* 2px */}
<View className="rounded">       {/* 4px */}
<View className="rounded-md">    {/* 6px */}
<View className="rounded-lg">    {/* 8px */}
<View className="rounded-xl">    {/* 12px */}
<View className="rounded-2xl">   {/* 16px */}
<View className="rounded-full">  {/* Circular */}

// Shadows (platform-aware)
<View className="shadow-sm bg-card rounded-lg p-4">   {/* Subtle */}
<View className="shadow-md bg-card rounded-lg p-4">   {/* Medium */}
<View className="shadow-lg bg-card rounded-lg p-4">   {/* Prominent */}

// iOS-specific shadow + Android elevation
<View className="ios:shadow-lg android:elevation-4 bg-card rounded-xl p-4">
  <Text className="text-card-foreground">Platform-optimized shadow</Text>
</View>
```

---

## 6. Component Composition with cn()

### Variant pattern (like CVA)
```typescript
import { cn } from '~/lib/utils';
import { View, Text, Pressable } from 'react-native';

interface ChipProps {
  label: string;
  variant?: 'default' | 'success' | 'warning' | 'error';
  size?: 'sm' | 'md' | 'lg';
  onPress?: () => void;
  className?: string;
}

const chipVariants = {
  default: 'bg-secondary',
  success: 'bg-green-100 dark:bg-green-900',
  warning: 'bg-yellow-100 dark:bg-yellow-900',
  error: 'bg-red-100 dark:bg-red-900',
};

const chipTextVariants = {
  default: 'text-secondary-foreground',
  success: 'text-green-800 dark:text-green-200',
  warning: 'text-yellow-800 dark:text-yellow-200',
  error: 'text-red-800 dark:text-red-200',
};

const chipSizes = {
  sm: 'px-2 py-0.5',
  md: 'px-3 py-1',
  lg: 'px-4 py-1.5',
};

const chipTextSizes = {
  sm: 'text-xs',
  md: 'text-sm',
  lg: 'text-base',
};

export function Chip({ label, variant = 'default', size = 'md', onPress, className }: ChipProps) {
  const Wrapper = onPress ? Pressable : View;
  return (
    <Wrapper
      onPress={onPress}
      className={cn(
        "rounded-full",
        chipVariants[variant],
        chipSizes[size],
        onPress && "active:opacity-80",
        className
      )}
    >
      <Text className={cn(
        "font-medium",
        chipTextVariants[variant],
        chipTextSizes[size],
      )}>
        {label}
      </Text>
    </Wrapper>
  );
}
```

---

## 7. Responsive Screen

```typescript
import { useWindowDimensions } from 'react-native';

// Use Tailwind breakpoints for layout
<View className="flex-col md:flex-row gap-4 px-4">
  <View className="w-full md:flex-1">
    <Text>Left column</Text>
  </View>
  <View className="w-full md:flex-1">
    <Text>Right column</Text>
  </View>
</View>

// Use useWindowDimensions for dynamic values
function AdaptiveGrid() {
  const { width } = useWindowDimensions();
  const numColumns = width > 768 ? 3 : width > 480 ? 2 : 1;

  return (
    <FlatList
      data={items}
      numColumns={numColumns}
      key={numColumns} // Force re-render on column change
      renderItem={({ item }) => (
        <View className="flex-1 p-2">
          <Card><CardContent><Text>{item.title}</Text></CardContent></Card>
        </View>
      )}
    />
  );
}
```

---

## 8. Platform-Specific Styles

```typescript
// NativeWind platform prefixes
<View className="
  px-4 py-6
  ios:pt-safe
  android:pt-8
  web:max-w-screen-lg web:mx-auto
">

// Status bar area
<View className="ios:pt-14 android:pt-10">

// Platform-specific interactions
<Pressable className="
  active:opacity-80
  ios:active:scale-[0.98]
  android:android_ripple
">

// Conditional by Platform import
import { Platform } from 'react-native';
<View className={cn(
  "p-4 rounded-lg bg-card",
  Platform.OS === 'ios' && "shadow-lg",
  Platform.OS === 'android' && "elevation-4",
)}>
```

---

## 9. List Item Performance

```typescript
import { FlatList, View, Text } from 'react-native';
import { useCallback, memo } from 'react';
import { Card, CardContent } from '~/components/ui/card';

interface Item {
  id: string;
  title: string;
  subtitle: string;
}

// ✅ Memoized list item
const ListItem = memo(function ListItem({
  item,
  onPress,
}: {
  item: Item;
  onPress: (id: string) => void;
}) {
  return (
    <Pressable onPress={() => onPress(item.id)}>
      <Card className="mx-4 mb-2">
        <CardContent className="flex-row items-center gap-3 py-3">
          <View className="w-10 h-10 rounded-full bg-primary/10 items-center justify-center">
            <Text className="text-primary font-bold">{item.title[0]}</Text>
          </View>
          <View className="flex-1">
            <Text className="text-foreground font-medium">{item.title}</Text>
            <Text className="text-muted-foreground text-sm">{item.subtitle}</Text>
          </View>
        </CardContent>
      </Card>
    </Pressable>
  );
});

// ✅ Optimized FlatList
function ItemList({ items }: { items: Item[] }) {
  const handlePress = useCallback((id: string) => {
    router.push(`/item/${id}`);
  }, []);

  const renderItem = useCallback(({ item }: { item: Item }) => (
    <ListItem item={item} onPress={handlePress} />
  ), [handlePress]);

  const keyExtractor = useCallback((item: Item) => item.id, []);

  return (
    <FlatList
      data={items}
      renderItem={renderItem}
      keyExtractor={keyExtractor}
      contentContainerClassName="py-4"
      showsVerticalScrollIndicator={false}
      initialNumToRender={10}
      maxToRenderPerBatch={10}
      windowSize={5}
    />
  );
}

// ❌ NEVER do this for large lists
<ScrollView>
  {items.map((item) => (
    <Card key={item.id}>...</Card>  // All items rendered at once!
  ))}
</ScrollView>
```

---

## 10. Image Handling

```bash
npx expo install expo-image
```

```typescript
import { Image } from 'expo-image';

// Basic image with placeholder
<Image
  source={{ uri: 'https://example.com/photo.jpg' }}
  placeholder={{ blurhash: 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH' }}
  contentFit="cover"
  transition={200}
  className="w-full h-48 rounded-lg"
/>

// Avatar with expo-image
<Image
  source={{ uri: user.avatarUrl }}
  className="w-12 h-12 rounded-full"
  contentFit="cover"
  transition={100}
/>

// Background image
<View className="relative h-64 rounded-xl overflow-hidden">
  <Image
    source={{ uri: coverUrl }}
    className="absolute inset-0"
    contentFit="cover"
  />
  <View className="absolute inset-0 bg-black/40" />
  <View className="absolute bottom-0 left-0 right-0 p-4">
    <Text className="text-white text-xl font-bold">Overlay Text</Text>
  </View>
</View>

// Cached & priority
<Image
  source={{ uri: url }}
  cachePolicy="memory-disk"
  priority="high"
  className="w-full aspect-video rounded-lg"
  contentFit="cover"
/>
```

---

## 11. Absolute Positioning

```typescript
// Overlay
<View className="relative">
  <Image source={{ uri }} className="w-full h-64" contentFit="cover" />
  <View className="absolute inset-0 bg-black/30" />
  <View className="absolute bottom-4 left-4 right-4">
    <Text className="text-white font-bold text-lg">Title</Text>
  </View>
</View>

// Badge on avatar
<View className="relative">
  <Avatar alt="User">
    <AvatarImage source={{ uri: avatar }} />
  </Avatar>
  <View className="absolute -top-1 -right-1 w-4 h-4 bg-green-500 rounded-full border-2 border-background" />
</View>

// FAB (Floating Action Button)
<View className="absolute bottom-6 right-6 z-50">
  <Button size="icon" className="w-14 h-14 rounded-full shadow-lg">
    <Plus size={24} className="text-primary-foreground" />
  </Button>
</View>

// Full screen overlay
<View className="absolute inset-0 z-50 bg-background/80 items-center justify-center">
  <ActivityIndicator size="large" />
</View>
```

---

## 12. Flex Patterns Cheatsheet

```typescript
// Vertical stack (default)
<View className="flex-1 gap-4">
  <View>Item 1</View>
  <View>Item 2</View>
</View>

// Horizontal row
<View className="flex-row items-center gap-2">
  <Icon />
  <Text>Label</Text>
</View>

// Space between (header pattern)
<View className="flex-row items-center justify-between px-4 py-3">
  <Text className="text-xl font-bold">Title</Text>
  <Button variant="ghost" size="icon"><Settings /></Button>
</View>

// Center content
<View className="flex-1 items-center justify-center">
  <Text>Centered</Text>
</View>

// Equal columns
<View className="flex-row gap-4">
  <View className="flex-1"><Card>...</Card></View>
  <View className="flex-1"><Card>...</Card></View>
</View>

// Fixed + flex
<View className="flex-row items-center gap-3">
  <Image className="w-12 h-12 rounded-full" />  {/* Fixed */}
  <View className="flex-1">                       {/* Takes remaining */}
    <Text>Title</Text>
    <Text>Subtitle</Text>
  </View>
  <Badge><Text>New</Text></Badge>                 {/* Fixed */}
</View>

// Wrap
<View className="flex-row flex-wrap gap-2">
  {tags.map(tag => (
    <Badge key={tag}><Text>{tag}</Text></Badge>
  ))}
</View>

// Bottom-aligned content
<View className="flex-1 justify-end pb-6 px-4">
  <Button className="w-full"><Text>Continue</Text></Button>
</View>

// Scroll with fixed footer
<View className="flex-1">
  <ScrollView className="flex-1" contentContainerClassName="px-4 py-6 gap-4">
    {/* Scrollable content */}
  </ScrollView>
  <View className="px-4 py-4 border-t border-border bg-background">
    <Button className="w-full"><Text>Submit</Text></Button>
  </View>
</View>
```
