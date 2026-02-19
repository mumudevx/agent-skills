# Expo Router v4 — Navigation Patterns

## 1. Core Concepts

Expo Router uses **file-based routing**: every file in the `app/` directory becomes a route.

```
app/index.tsx        → /
app/about.tsx        → /about
app/profile/[id].tsx → /profile/123
app/(tabs)/index.tsx → / (grouped, no URL impact)
```

Key principles:
- `app/` is the root directory for all routes
- `_layout.tsx` defines navigation structure (Stack, Tabs, Drawer)
- Route groups `(name)/` organize without affecting URL
- Every screen is a React component with `export default`

---

## 2. File Naming Conventions

| File | Purpose |
|------|---------|
| `index.tsx` | Default route for directory (`/` or `/folder/`) |
| `[id].tsx` | Dynamic route segment (`/profile/123`) |
| `[...slug].tsx` | Catch-all route (`/docs/a/b/c`) |
| `(group)/` | Route group — no URL impact |
| `+not-found.tsx` | 404 page |
| `_layout.tsx` | Layout wrapper for sibling routes |
| `+html.tsx` | Custom HTML wrapper (web only) |

```
app/
├── _layout.tsx           ← Root Stack
├── index.tsx             ← /
├── +not-found.tsx        ← 404
├── (auth)/
│   ├── _layout.tsx       ← Auth Stack
│   ├── login.tsx         ← /login
│   └── register.tsx      ← /register
├── (tabs)/
│   ├── _layout.tsx       ← Tab Bar
│   ├── index.tsx         ← / (Home tab)
│   ├── search.tsx        ← /search
│   └── profile.tsx       ← /profile
└── post/
    ├── [id].tsx          ← /post/123
    └── create.tsx        ← /post/create
```

---

## 3. Layout Files

### Stack Layout (default)
```typescript
// app/_layout.tsx
import { Stack } from 'expo-router';
import '../global.css';

export default function RootLayout() {
  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Screen name="(tabs)" />
      <Stack.Screen name="(auth)" />
      <Stack.Screen name="+not-found" />
    </Stack>
  );
}
```

### Tab Layout
```typescript
// app/(tabs)/_layout.tsx
import { Tabs } from 'expo-router';
import { Home, Search, User } from 'lucide-react-native';
import { useColorScheme } from 'nativewind';

export default function TabLayout() {
  const { colorScheme } = useColorScheme();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colorScheme === 'dark' ? '#93c5fd' : '#2563eb',
        tabBarStyle: {
          backgroundColor: colorScheme === 'dark' ? '#0f172a' : '#ffffff',
          borderTopColor: colorScheme === 'dark' ? '#1e293b' : '#e2e8f0',
        },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Home',
          tabBarIcon: ({ color, size }) => <Home color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="search"
        options={{
          title: 'Search',
          tabBarIcon: ({ color, size }) => <Search color={color} size={size} />,
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title: 'Profile',
          tabBarIcon: ({ color, size }) => <User color={color} size={size} />,
        }}
      />
    </Tabs>
  );
}
```

### Drawer Layout
```bash
npx expo install @react-navigation/drawer react-native-gesture-handler react-native-reanimated
```

```typescript
import { Drawer } from 'expo-router/drawer';
import { GestureHandlerRootView } from 'react-native-gesture-handler';

export default function DrawerLayout() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <Drawer>
        <Drawer.Screen name="index" options={{ title: 'Home' }} />
        <Drawer.Screen name="settings" options={{ title: 'Settings' }} />
      </Drawer>
    </GestureHandlerRootView>
  );
}
```

---

## 4. Navigation Hooks

```typescript
import {
  useRouter,
  useLocalSearchParams,
  useGlobalSearchParams,
  useSegments,
  usePathname,
  useNavigation,
} from 'expo-router';

// useRouter — imperative navigation
const router = useRouter();
router.push('/profile/123');          // Push new screen
router.replace('/(auth)/login');      // Replace current screen
router.back();                        // Go back
router.canGoBack();                   // Check if can go back
router.dismissAll();                  // Dismiss all modals

// useLocalSearchParams — typed route params
// In app/profile/[id].tsx:
const { id } = useLocalSearchParams<{ id: string }>();

// useGlobalSearchParams — query params from any route
const { q } = useGlobalSearchParams<{ q: string }>();

// useSegments — array of current route segments
const segments = useSegments();
// e.g., ['(tabs)', 'profile'] for /(tabs)/profile

// usePathname — current URL path
const pathname = usePathname();
// e.g., "/profile/123"
```

---

## 5. Link Component

```typescript
import { Link } from 'expo-router';
import { Text, Pressable } from 'react-native';
import { Button } from '~/components/ui/button';

// Basic link
<Link href="/about">
  <Text className="text-primary underline">About</Text>
</Link>

// With params
<Link href={`/post/${post.id}`}>
  <Text>Read more</Text>
</Link>

// Object href
<Link href={{ pathname: '/post/[id]', params: { id: '123' } }}>
  <Text>Post</Text>
</Link>

// asChild — use custom component as link
<Link href="/settings" asChild>
  <Pressable className="p-4 bg-card rounded-lg">
    <Text className="text-foreground">Settings</Text>
  </Pressable>
</Link>

// Replace instead of push
<Link href="/login" replace>
  <Text>Login</Text>
</Link>

// With RNR Button
<Link href="/create" asChild>
  <Button><Text>Create New</Text></Button>
</Link>
```

---

## 6. Auth Flow Pattern

### Protected routes with redirect
```typescript
// app/_layout.tsx
import { Stack, useRouter, useSegments } from 'expo-router';
import { useEffect } from 'react';
import { useAuth } from '~/hooks/useAuth';
import '../global.css';

export default function RootLayout() {
  const { user, isLoading } = useAuth();
  const segments = useSegments();
  const router = useRouter();

  useEffect(() => {
    if (isLoading) return;

    const inAuthGroup = segments[0] === '(auth)';

    if (!user && !inAuthGroup) {
      // Redirect to login if not authenticated
      router.replace('/(auth)/login');
    } else if (user && inAuthGroup) {
      // Redirect to home if authenticated
      router.replace('/(tabs)');
    }
  }, [user, segments, isLoading]);

  if (isLoading) {
    return <View className="flex-1 bg-background items-center justify-center">
      <ActivityIndicator size="large" />
    </View>;
  }

  return (
    <Stack screenOptions={{ headerShown: false }}>
      <Stack.Screen name="(auth)" />
      <Stack.Screen name="(tabs)" />
    </Stack>
  );
}
```

### Auth context
```typescript
// contexts/AuthContext.tsx
import { createContext, useContext, useState, useEffect } from 'react';

interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signOut: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Check stored auth on mount
    checkAuth().then(setUser).finally(() => setIsLoading(false));
  }, []);

  return (
    <AuthContext.Provider value={{ user, isLoading, signIn, signOut }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
};
```

---

## 7. Tab Navigation — Advanced

```typescript
// Custom tab bar badge
<Tabs.Screen
  name="notifications"
  options={{
    title: 'Notifications',
    tabBarIcon: ({ color, size }) => <Bell color={color} size={size} />,
    tabBarBadge: unreadCount > 0 ? unreadCount : undefined,
    tabBarBadgeStyle: { backgroundColor: 'hsl(0 84.2% 60.2%)' },
  }}
/>

// Hide tab bar on specific screens
<Tabs.Screen
  name="chat"
  options={{
    tabBarStyle: { display: 'none' },
  }}
/>

// Hide a screen from tab bar but keep it navigable
<Tabs.Screen
  name="settings"
  options={{
    href: null, // Hides from tab bar
  }}
/>
```

---

## 8. Stack Navigation — Advanced

```typescript
// Header customization
<Stack.Screen
  name="profile/[id]"
  options={{
    headerShown: true,
    headerTitle: 'Profile',
    headerTintColor: 'hsl(var(--foreground))',
    headerStyle: { backgroundColor: 'hsl(var(--background))' },
    headerRight: () => (
      <Button variant="ghost" size="icon" onPress={handleEdit}>
        <Edit size={20} className="text-foreground" />
      </Button>
    ),
  }}
/>

// Modal presentation
<Stack.Screen
  name="modal"
  options={{
    presentation: 'modal',
    animation: 'slide_from_bottom',
    headerShown: true,
    headerTitle: 'Create',
  }}
/>

// Transparent modal
<Stack.Screen
  name="overlay"
  options={{
    presentation: 'transparentModal',
    animation: 'fade',
    headerShown: false,
  }}
/>

// Dynamic options from screen
// In app/post/[id].tsx:
import { Stack } from 'expo-router';

export default function PostScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  return (
    <>
      <Stack.Screen options={{ headerTitle: `Post #${id}` }} />
      <View className="flex-1 bg-background">
        {/* content */}
      </View>
    </>
  );
}
```

---

## 9. Deep Linking

### app.json configuration
```json
{
  "expo": {
    "scheme": "myapp",
    "android": {
      "intentFilters": [
        {
          "action": "VIEW",
          "data": [{ "scheme": "myapp" }],
          "category": ["BROWSABLE", "DEFAULT"]
        }
      ]
    },
    "ios": {
      "bundleIdentifier": "com.example.myapp",
      "associatedDomains": ["applinks:example.com"]
    }
  }
}
```

Links like `myapp://post/123` automatically route to `app/post/[id].tsx`.

---

## 10. Route Groups

Route groups use parentheses `()` and don't affect the URL:

```
app/(tabs)/index.tsx    → URL: /          (not /tabs/)
app/(auth)/login.tsx    → URL: /login     (not /auth/login)
app/(admin)/users.tsx   → URL: /users
```

Use groups to:
- Apply different layouts to different sections
- Organize code without URL impact
- Share layout between related screens

---

## 11. Dynamic Routes

```typescript
// app/user/[id].tsx — single dynamic segment
import { useLocalSearchParams } from 'expo-router';

export default function UserScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  return <Text>User: {id}</Text>;
}

// app/docs/[...slug].tsx — catch-all
export default function DocsScreen() {
  const { slug } = useLocalSearchParams<{ slug: string[] }>();
  // /docs/getting-started/install → slug = ['getting-started', 'install']
  return <Text>Path: {slug?.join('/')}</Text>;
}

// Navigate to dynamic route
router.push(`/user/${userId}`);
router.push({ pathname: '/user/[id]', params: { id: userId } });
```

---

## 12. Nested Navigation

### Stack inside Tabs
```
app/(tabs)/_layout.tsx       ← Tabs
app/(tabs)/home/_layout.tsx  ← Stack inside Home tab
app/(tabs)/home/index.tsx    ← Home screen
app/(tabs)/home/details.tsx  ← Details (pushes in Home tab stack)
```

### Modal from Tabs
```typescript
// app/_layout.tsx
<Stack>
  <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
  <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
</Stack>

// From any tab screen:
router.push('/modal');
```

---

## 13. SafeAreaProvider Setup

```typescript
// app/_layout.tsx
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Stack } from 'expo-router';
import '../global.css';

export default function RootLayout() {
  return (
    <GestureHandlerRootView style={{ flex: 1 }}>
      <SafeAreaProvider>
        <Stack screenOptions={{ headerShown: false }} />
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
}

// In screens:
import { SafeAreaView } from 'react-native-safe-area-context';

export default function Screen() {
  return (
    <SafeAreaView className="flex-1 bg-background">
      {/* content */}
    </SafeAreaView>
  );
}

// Or use the hook for custom padding:
import { useSafeAreaInsets } from 'react-native-safe-area-context';

export default function Screen() {
  const insets = useSafeAreaInsets();
  return (
    <View className="flex-1 bg-background" style={{ paddingTop: insets.top }}>
      {/* content */}
    </View>
  );
}
```

---

## 14. Loading & Error States

### Loading screen
```typescript
// app/_layout.tsx
import { SplashScreen, Stack } from 'expo-router';
import { useFonts } from 'expo-font';
import { useEffect } from 'react';

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [fontsLoaded] = useFonts({
    'Inter-Regular': require('../assets/fonts/Inter-Regular.ttf'),
  });

  useEffect(() => {
    if (fontsLoaded) SplashScreen.hideAsync();
  }, [fontsLoaded]);

  if (!fontsLoaded) return null;

  return <Stack screenOptions={{ headerShown: false }} />;
}
```

### Error boundary
```typescript
// app/+not-found.tsx
import { Link, Stack } from 'expo-router';
import { View, Text } from 'react-native';
import { Button } from '~/components/ui/button';

export default function NotFoundScreen() {
  return (
    <>
      <Stack.Screen options={{ title: 'Oops!' }} />
      <View className="flex-1 bg-background items-center justify-center px-4 gap-4">
        <Text className="text-4xl font-bold text-foreground">404</Text>
        <Text className="text-muted-foreground text-center">
          This screen doesn't exist.
        </Text>
        <Link href="/" asChild>
          <Button><Text>Go Home</Text></Button>
        </Link>
      </View>
    </>
  );
}
```

---

## 15. NativeWind Integration

### Critical: Import global.css in root layout
```typescript
// app/_layout.tsx — MUST have this import
import '../global.css';
```

### Using NativeWind with navigation
```typescript
// Tab bar with theme colors
<Tabs screenOptions={{
  tabBarActiveTintColor: 'hsl(221.2 83.2% 53.3%)',
  tabBarInactiveTintColor: 'hsl(215.4 16.3% 46.9%)',
  tabBarStyle: {
    backgroundColor: 'hsl(0 0% 100%)',
    borderTopColor: 'hsl(214.3 31.8% 91.4%)',
  },
}}>

// Or use useColorScheme for dynamic theming:
const { colorScheme } = useColorScheme();
const isDark = colorScheme === 'dark';
```

### contentContainerClassName for ScrollView
```typescript
// NativeWind v4 supports contentContainerClassName
<ScrollView
  className="flex-1"
  contentContainerClassName="px-4 py-6 gap-4"
>
  {/* content */}
</ScrollView>

// For FlatList
<FlatList
  className="flex-1"
  contentContainerClassName="px-4 gap-2"
  data={items}
  renderItem={renderItem}
/>
```
