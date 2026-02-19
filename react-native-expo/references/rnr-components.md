# React Native Reusables — Component Reference

## 1. Setup & CLI

```bash
# Initialize RNR in your project (one-time)
npx @react-native-reusables/cli@latest init

# Add a component
npx @react-native-reusables/cli@latest add [component-name]

# Components are copied to ~/components/ui/
```

### shadcn MCP Registry (alternative)
Add to `components.json`:
```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "registries": {
    "@rnr": "https://reactnativereusables.com/r/nativewind/{name}.json"
  }
}
```

### Dependencies
Most RNR components need these peer deps:
```bash
npx expo install @rn-primitives/slot @rn-primitives/types
npm install class-variance-authority clsx tailwind-merge
```

---

## 2. Button

```bash
npx @react-native-reusables/cli@latest add button
```

```typescript
import { Button } from '~/components/ui/button';
import { Text } from '~/components/ui/text';

// Variants
<Button variant="default" onPress={() => {}}>
  <Text>Default</Text>
</Button>

<Button variant="destructive" onPress={() => {}}>
  <Text>Delete</Text>
</Button>

<Button variant="outline" onPress={() => {}}>
  <Text>Outline</Text>
</Button>

<Button variant="secondary" onPress={() => {}}>
  <Text>Secondary</Text>
</Button>

<Button variant="ghost" onPress={() => {}}>
  <Text>Ghost</Text>
</Button>

<Button variant="link" onPress={() => {}}>
  <Text>Link</Text>
</Button>

// Sizes
<Button size="default"><Text>Default</Text></Button>
<Button size="sm"><Text>Small</Text></Button>
<Button size="lg"><Text>Large</Text></Button>
<Button size="icon"><Text>🔔</Text></Button>

// Disabled
<Button disabled onPress={() => {}}>
  <Text>Disabled</Text>
</Button>

// Loading state
import { ActivityIndicator } from 'react-native';

function LoadingButton({ loading, onPress, children }: {
  loading: boolean;
  onPress: () => void;
  children: React.ReactNode;
}) {
  return (
    <Button disabled={loading} onPress={onPress}>
      {loading ? (
        <ActivityIndicator size="small" color="hsl(var(--primary-foreground))" />
      ) : children}
    </Button>
  );
}

// With icon
import { Mail } from 'lucide-react-native';
<Button variant="outline" className="flex-row gap-2">
  <Mail size={16} className="text-foreground" />
  <Text>Send Email</Text>
</Button>

// Full width
<Button className="w-full" onPress={() => {}}>
  <Text>Full Width Button</Text>
</Button>
```

---

## 3. Input

```bash
npx @react-native-reusables/cli@latest add input
```

```typescript
import { Input } from '~/components/ui/input';
import { Label } from '~/components/ui/label';
import { View } from 'react-native';
import { useState } from 'react';

// Basic controlled input
function EmailInput() {
  const [email, setEmail] = useState('');
  return (
    <View className="gap-2">
      <Label nativeID="email">Email</Label>
      <Input
        placeholder="you@example.com"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
        aria-labelledby="email"
      />
    </View>
  );
}

// Password input
function PasswordInput() {
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  return (
    <View className="gap-2">
      <Label nativeID="password">Password</Label>
      <View className="relative">
        <Input
          placeholder="Enter password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry={!showPassword}
          aria-labelledby="password"
        />
      </View>
    </View>
  );
}

// With className override
<Input className="bg-muted border-0" placeholder="Search..." />

// With error state
<Input className="border-destructive" placeholder="Required field" />
<Text className="text-destructive text-sm mt-1">This field is required</Text>
```

---

## 4. Card

```bash
npx @react-native-reusables/cli@latest add card
```

```typescript
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from '~/components/ui/card';
import { Text, View } from 'react-native';
import { Button } from '~/components/ui/button';

// Full card
<Card className="mx-4">
  <CardHeader>
    <CardTitle>Create Project</CardTitle>
    <CardDescription>Deploy your new project in one-click.</CardDescription>
  </CardHeader>
  <CardContent className="gap-4">
    <View className="gap-2">
      <Label nativeID="name">Name</Label>
      <Input placeholder="Project name" aria-labelledby="name" />
    </View>
  </CardContent>
  <CardFooter className="flex-row justify-end gap-2">
    <Button variant="outline"><Text>Cancel</Text></Button>
    <Button><Text>Deploy</Text></Button>
  </CardFooter>
</Card>

// Simple stat card
<Card>
  <CardContent className="pt-6">
    <Text className="text-sm text-muted-foreground">Total Revenue</Text>
    <Text className="text-3xl font-bold text-foreground">$45,231</Text>
    <Text className="text-xs text-muted-foreground mt-1">+20.1% from last month</Text>
  </CardContent>
</Card>

// Pressable card
import { Pressable } from 'react-native';
<Pressable onPress={() => router.push('/details')}>
  <Card className="active:opacity-80">
    <CardHeader>
      <CardTitle>Tap to navigate</CardTitle>
    </CardHeader>
  </Card>
</Pressable>
```

---

## 5. Dialog

```bash
npx @react-native-reusables/cli@latest add dialog
```

```typescript
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '~/components/ui/dialog';
import { Text } from 'react-native';
import { Button } from '~/components/ui/button';
import { Input } from '~/components/ui/input';

// Basic dialog
<Dialog>
  <DialogTrigger asChild>
    <Button><Text>Edit Profile</Text></Button>
  </DialogTrigger>
  <DialogContent className="sm:max-w-[425px]">
    <DialogHeader>
      <DialogTitle>Edit Profile</DialogTitle>
      <DialogDescription>
        Make changes to your profile here. Click save when you're done.
      </DialogDescription>
    </DialogHeader>
    <View className="gap-4 py-4">
      <View className="gap-2">
        <Label nativeID="name">Name</Label>
        <Input aria-labelledby="name" defaultValue="John Doe" />
      </View>
    </View>
    <DialogFooter>
      <DialogClose asChild>
        <Button><Text>Save Changes</Text></Button>
      </DialogClose>
    </DialogFooter>
  </DialogContent>
</Dialog>

// Controlled dialog
function ControlledDialog() {
  const [open, setOpen] = useState(false);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button><Text>Open</Text></Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Controlled</DialogTitle>
        </DialogHeader>
        <Button onPress={() => setOpen(false)}>
          <Text>Close Programmatically</Text>
        </Button>
      </DialogContent>
    </Dialog>
  );
}
```

---

## 6. Sheet (Bottom Sheet)

```bash
npx @react-native-reusables/cli@latest add bottom-sheet
```

```typescript
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
  SheetFooter,
  SheetClose,
} from '~/components/ui/bottom-sheet';

<Sheet>
  <SheetTrigger asChild>
    <Button variant="outline"><Text>Open Sheet</Text></Button>
  </SheetTrigger>
  <SheetContent side="bottom">
    <SheetHeader>
      <SheetTitle>Filter Options</SheetTitle>
      <SheetDescription>
        Adjust the filters below
      </SheetDescription>
    </SheetHeader>
    <View className="gap-4 py-4">
      <Text className="text-foreground">Sheet content here</Text>
    </View>
    <SheetFooter>
      <SheetClose asChild>
        <Button><Text>Apply Filters</Text></Button>
      </SheetClose>
    </SheetFooter>
  </SheetContent>
</Sheet>
```

---

## 7. Select

```bash
npx @react-native-reusables/cli@latest add select
```

```typescript
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from '~/components/ui/select';
import { useState } from 'react';

function FruitSelect() {
  const [value, setValue] = useState<{ value: string; label: string } | undefined>();

  return (
    <Select value={value} onValueChange={setValue}>
      <SelectTrigger className="w-full">
        <SelectValue className="text-foreground" placeholder="Select a fruit" />
      </SelectTrigger>
      <SelectContent>
        <SelectGroup>
          <SelectLabel>Fruits</SelectLabel>
          <SelectItem label="Apple" value="apple">Apple</SelectItem>
          <SelectItem label="Banana" value="banana">Banana</SelectItem>
          <SelectItem label="Orange" value="orange">Orange</SelectItem>
        </SelectGroup>
      </SelectContent>
    </Select>
  );
}
```

---

## 8. Badge

```bash
npx @react-native-reusables/cli@latest add badge
```

```typescript
import { Badge } from '~/components/ui/badge';
import { Text } from '~/components/ui/text';

// Variants
<Badge variant="default"><Text>Default</Text></Badge>
<Badge variant="secondary"><Text>Secondary</Text></Badge>
<Badge variant="destructive"><Text>Destructive</Text></Badge>
<Badge variant="outline"><Text>Outline</Text></Badge>

// In a list item
<View className="flex-row items-center justify-between">
  <Text className="text-foreground">Messages</Text>
  <Badge><Text>3</Text></Badge>
</View>
```

---

## 9. Avatar

```bash
npx @react-native-reusables/cli@latest add avatar
```

```typescript
import { Avatar, AvatarImage, AvatarFallback } from '~/components/ui/avatar';
import { Text } from 'react-native';

// With image
<Avatar alt="User avatar">
  <AvatarImage source={{ uri: 'https://github.com/shadcn.png' }} />
  <AvatarFallback>
    <Text className="text-foreground">CN</Text>
  </AvatarFallback>
</Avatar>

// Custom size
<Avatar alt="Small avatar" className="w-8 h-8">
  <AvatarImage source={{ uri: user.avatarUrl }} />
  <AvatarFallback>
    <Text className="text-xs">{user.initials}</Text>
  </AvatarFallback>
</Avatar>

// Avatar group
<View className="flex-row -space-x-3">
  {users.map((user) => (
    <Avatar key={user.id} alt={user.name} className="border-2 border-background">
      <AvatarImage source={{ uri: user.avatar }} />
      <AvatarFallback><Text>{user.initials}</Text></AvatarFallback>
    </Avatar>
  ))}
</View>
```

---

## 10. Checkbox

```bash
npx @react-native-reusables/cli@latest add checkbox
```

```typescript
import { Checkbox } from '~/components/ui/checkbox';
import { Label } from '~/components/ui/label';
import { View } from 'react-native';
import { useState } from 'react';

function TermsCheckbox() {
  const [checked, setChecked] = useState(false);

  return (
    <View className="flex-row items-center gap-2">
      <Checkbox
        checked={checked}
        onCheckedChange={setChecked}
        nativeID="terms"
      />
      <Label nativeID="terms" onPress={() => setChecked(!checked)}>
        Accept terms and conditions
      </Label>
    </View>
  );
}

// In a list
function TodoList({ items }: { items: Array<{ id: string; title: string; done: boolean }> }) {
  return (
    <View className="gap-3">
      {items.map((item) => (
        <View key={item.id} className="flex-row items-center gap-3">
          <Checkbox checked={item.done} onCheckedChange={() => toggleItem(item.id)} />
          <Text className={cn("text-foreground", item.done && "line-through text-muted-foreground")}>
            {item.title}
          </Text>
        </View>
      ))}
    </View>
  );
}
```

---

## 11. Switch

```bash
npx @react-native-reusables/cli@latest add switch
```

```typescript
import { Switch } from '~/components/ui/switch';
import { Label } from '~/components/ui/label';
import { View } from 'react-native';
import { useState } from 'react';

function NotificationSwitch() {
  const [enabled, setEnabled] = useState(false);

  return (
    <View className="flex-row items-center justify-between">
      <Label nativeID="notifications">Push Notifications</Label>
      <Switch
        checked={enabled}
        onCheckedChange={setEnabled}
        nativeID="notifications"
      />
    </View>
  );
}
```

---

## 12. Tabs

```bash
npx @react-native-reusables/cli@latest add tabs
```

```typescript
import { Tabs, TabsContent, TabsList, TabsTrigger } from '~/components/ui/tabs';
import { Text, View } from 'react-native';
import { useState } from 'react';

function AccountTabs() {
  const [value, setValue] = useState('account');

  return (
    <Tabs value={value} onValueChange={setValue}>
      <TabsList className="flex-row">
        <TabsTrigger value="account" className="flex-1">
          <Text>Account</Text>
        </TabsTrigger>
        <TabsTrigger value="password" className="flex-1">
          <Text>Password</Text>
        </TabsTrigger>
      </TabsList>
      <TabsContent value="account">
        <View className="p-4 gap-4">
          <Text className="text-foreground">Account settings here</Text>
        </View>
      </TabsContent>
      <TabsContent value="password">
        <View className="p-4 gap-4">
          <Text className="text-foreground">Password settings here</Text>
        </View>
      </TabsContent>
    </Tabs>
  );
}
```

---

## 13. Progress

```bash
npx @react-native-reusables/cli@latest add progress
```

```typescript
import { Progress } from '~/components/ui/progress';

// Basic
<Progress value={60} className="w-full" />

// With label
<View className="gap-2">
  <View className="flex-row justify-between">
    <Text className="text-sm text-muted-foreground">Upload Progress</Text>
    <Text className="text-sm text-muted-foreground">60%</Text>
  </View>
  <Progress value={60} />
</View>
```

---

## 14. Skeleton

```bash
npx @react-native-reusables/cli@latest add skeleton
```

```typescript
import { Skeleton } from '~/components/ui/skeleton';
import { View } from 'react-native';

// Card skeleton
function CardSkeleton() {
  return (
    <View className="p-4 gap-4">
      <View className="flex-row items-center gap-3">
        <Skeleton className="w-12 h-12 rounded-full" />
        <View className="gap-2 flex-1">
          <Skeleton className="h-4 w-3/4 rounded" />
          <Skeleton className="h-3 w-1/2 rounded" />
        </View>
      </View>
      <Skeleton className="h-32 w-full rounded-lg" />
      <View className="gap-2">
        <Skeleton className="h-4 w-full rounded" />
        <Skeleton className="h-4 w-5/6 rounded" />
      </View>
    </View>
  );
}

// List skeleton
function ListSkeleton({ count = 5 }: { count?: number }) {
  return (
    <View className="gap-4 p-4">
      {Array.from({ length: count }).map((_, i) => (
        <View key={i} className="flex-row items-center gap-3">
          <Skeleton className="w-10 h-10 rounded-full" />
          <View className="flex-1 gap-1.5">
            <Skeleton className="h-4 w-2/3 rounded" />
            <Skeleton className="h-3 w-1/3 rounded" />
          </View>
        </View>
      ))}
    </View>
  );
}
```

---

## 15. Alert Dialog

```bash
npx @react-native-reusables/cli@latest add alert-dialog
```

```typescript
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '~/components/ui/alert-dialog';

// Confirm delete
<AlertDialog>
  <AlertDialogTrigger asChild>
    <Button variant="destructive"><Text>Delete Account</Text></Button>
  </AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>Are you absolutely sure?</AlertDialogTitle>
      <AlertDialogDescription>
        This action cannot be undone. This will permanently delete your account.
      </AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel><Text>Cancel</Text></AlertDialogCancel>
      <AlertDialogAction onPress={handleDelete}>
        <Text>Delete</Text>
      </AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

---

## 16. Dropdown Menu

```bash
npx @react-native-reusables/cli@latest add dropdown-menu
```

```typescript
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuGroup,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '~/components/ui/dropdown-menu';
import { MoreVertical } from 'lucide-react-native';

<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="ghost" size="icon">
      <MoreVertical className="text-foreground" size={20} />
    </Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent className="w-56">
    <DropdownMenuLabel>My Account</DropdownMenuLabel>
    <DropdownMenuSeparator />
    <DropdownMenuGroup>
      <DropdownMenuItem onPress={() => router.push('/profile')}>
        <Text>Profile</Text>
      </DropdownMenuItem>
      <DropdownMenuItem onPress={() => router.push('/settings')}>
        <Text>Settings</Text>
      </DropdownMenuItem>
    </DropdownMenuGroup>
    <DropdownMenuSeparator />
    <DropdownMenuItem onPress={handleLogout}>
      <Text className="text-destructive">Log out</Text>
    </DropdownMenuItem>
  </DropdownMenuContent>
</DropdownMenu>
```

---

## 17. Separator

```bash
npx @react-native-reusables/cli@latest add separator
```

```typescript
import { Separator } from '~/components/ui/separator';

// Horizontal (default)
<View className="gap-4">
  <Text className="text-foreground">Section 1</Text>
  <Separator />
  <Text className="text-foreground">Section 2</Text>
</View>

// Vertical
<View className="flex-row items-center h-8 gap-4">
  <Text>Left</Text>
  <Separator orientation="vertical" />
  <Text>Right</Text>
</View>

// With label
<View className="flex-row items-center gap-4">
  <Separator className="flex-1" />
  <Text className="text-muted-foreground text-sm">OR</Text>
  <Separator className="flex-1" />
</View>
```

---

## 18. Label

```bash
npx @react-native-reusables/cli@latest add label
```

```typescript
import { Label } from '~/components/ui/label';
import { Input } from '~/components/ui/input';
import { View } from 'react-native';

// Basic form field
<View className="gap-1.5">
  <Label nativeID="email">Email address</Label>
  <Input
    aria-labelledby="email"
    placeholder="you@example.com"
    keyboardType="email-address"
  />
</View>

// Required field
<View className="gap-1.5">
  <View className="flex-row">
    <Label nativeID="name">Name</Label>
    <Text className="text-destructive ml-1">*</Text>
  </View>
  <Input aria-labelledby="name" placeholder="John Doe" />
</View>
```

---

## 19. Customization Pattern

### Via className prop
All RNR components accept `className` for style overrides:
```typescript
<Button className="rounded-full px-8" variant="default">
  <Text>Rounded Button</Text>
</Button>

<Card className="border-0 shadow-lg">
  <CardContent className="p-8">
    <Text>Custom card</Text>
  </CardContent>
</Card>
```

### Editing source directly
RNR copies components to `~/components/ui/`. You own the source:

```typescript
// ~/components/ui/button.tsx — edit the variants directly
const buttonVariants = cva(
  'flex-row items-center justify-center rounded-md',
  {
    variants: {
      variant: {
        default: 'bg-primary active:bg-primary/90',
        // Add your own variant:
        gradient: 'bg-gradient-to-r from-purple-500 to-pink-500',
      },
      size: {
        default: 'h-10 px-4 py-2',
        sm: 'h-9 rounded-md px-3',
        lg: 'h-11 rounded-md px-8',
        icon: 'h-10 w-10',
        // Add your own size:
        xl: 'h-14 rounded-xl px-10',
      },
    },
  }
);
```

### Creating compound components
```typescript
// ~/components/feature/user-card.tsx
import { Card, CardContent } from '~/components/ui/card';
import { Avatar, AvatarImage, AvatarFallback } from '~/components/ui/avatar';
import { Badge } from '~/components/ui/badge';
import { cn } from '~/lib/utils';

interface UserCardProps {
  name: string;
  email: string;
  avatar?: string;
  role: 'admin' | 'user';
  className?: string;
}

export function UserCard({ name, email, avatar, role, className }: UserCardProps) {
  return (
    <Card className={cn("", className)}>
      <CardContent className="flex-row items-center gap-3 pt-4">
        <Avatar alt={name}>
          <AvatarImage source={{ uri: avatar }} />
          <AvatarFallback>
            <Text>{name.slice(0, 2).toUpperCase()}</Text>
          </AvatarFallback>
        </Avatar>
        <View className="flex-1">
          <Text className="text-foreground font-medium">{name}</Text>
          <Text className="text-muted-foreground text-sm">{email}</Text>
        </View>
        <Badge variant={role === 'admin' ? 'default' : 'secondary'}>
          <Text>{role}</Text>
        </Badge>
      </CardContent>
    </Card>
  );
}
```
