# React Native Reanimated 3 Patterns

## Installation

```bash
npx expo install react-native-reanimated
```

Add to `babel.config.js`:
```js
module.exports = function (api) {
  api.cache(true);
  return {
    presets: ['babel-preset-expo'],
    plugins: ['react-native-reanimated/plugin'], // Must be last
  };
};
```

---

## Core Concepts

### useSharedValue
Values that live on the UI thread for 60fps animations:

```typescript
import { useSharedValue } from 'react-native-reanimated';

const opacity = useSharedValue(1);
const translateX = useSharedValue(0);
const scale = useSharedValue(1);

// Update (triggers animation on UI thread)
opacity.value = 0;
translateX.value = 100;
```

### useAnimatedStyle
Derive styles from shared values:

```typescript
import Animated, { useAnimatedStyle, useSharedValue } from 'react-native-reanimated';

function FadeView() {
  const opacity = useSharedValue(1);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
  }));

  return (
    <Animated.View className="bg-card rounded-xl p-4" style={animatedStyle}>
      <Text className="text-card-foreground">Animated content</Text>
    </Animated.View>
  );
}
```

---

## Animation Functions

### withSpring — Physics-based
```typescript
import { withSpring } from 'react-native-reanimated';

// Default spring
scale.value = withSpring(1.2);

// Custom spring config
scale.value = withSpring(1.2, {
  damping: 15,
  stiffness: 150,
  mass: 1,
});

// Snappy preset
const SNAPPY = { damping: 15, stiffness: 200 };
translateX.value = withSpring(100, SNAPPY);

// Bouncy preset
const BOUNCY = { damping: 8, stiffness: 100 };
scale.value = withSpring(1.5, BOUNCY);
```

### withTiming — Duration-based
```typescript
import { withTiming, Easing } from 'react-native-reanimated';

// Default (300ms)
opacity.value = withTiming(0);

// Custom duration + easing
opacity.value = withTiming(0, {
  duration: 500,
  easing: Easing.bezier(0.25, 0.1, 0.25, 1),
});

// Common easings
Easing.linear
Easing.ease         // default
Easing.inOut(Easing.ease)
Easing.bezier(0.25, 0.1, 0.25, 1)  // ease-out
```

### withSequence — Chain animations
```typescript
import { withSequence, withTiming, withSpring } from 'react-native-reanimated';

// Shake animation
translateX.value = withSequence(
  withTiming(-10, { duration: 50 }),
  withTiming(10, { duration: 50 }),
  withTiming(-10, { duration: 50 }),
  withTiming(0, { duration: 50 }),
);

// Scale bounce
scale.value = withSequence(
  withTiming(1.2, { duration: 100 }),
  withSpring(1),
);
```

### withDelay
```typescript
import { withDelay, withTiming } from 'react-native-reanimated';

// Delay before animation
opacity.value = withDelay(500, withTiming(1, { duration: 300 }));

// Staggered list items
items.forEach((_, index) => {
  itemOpacities[index].value = withDelay(
    index * 100,
    withTiming(1, { duration: 300 })
  );
});
```

### withRepeat
```typescript
import { withRepeat, withTiming, withSequence } from 'react-native-reanimated';

// Infinite pulse
scale.value = withRepeat(
  withSequence(
    withTiming(1.1, { duration: 1000 }),
    withTiming(1.0, { duration: 1000 }),
  ),
  -1, // -1 = infinite
  true // reverse
);

// Rotate spinner
rotation.value = withRepeat(
  withTiming(360, { duration: 1000, easing: Easing.linear }),
  -1,
  false
);
```

---

## Callbacks

### runOnJS — Call JS from UI thread
```typescript
import { runOnJS } from 'react-native-reanimated';

const handleAnimationEnd = () => {
  // This runs on JS thread
  setIsVisible(false);
  router.back();
};

opacity.value = withTiming(0, { duration: 300 }, (finished) => {
  if (finished) {
    runOnJS(handleAnimationEnd)();
  }
});
```

### useAnimatedReaction
```typescript
import { useAnimatedReaction, runOnJS } from 'react-native-reanimated';

useAnimatedReaction(
  () => translateX.value,
  (currentValue, previousValue) => {
    if (currentValue > 200 && (previousValue ?? 0) <= 200) {
      runOnJS(onThresholdReached)();
    }
  }
);
```

---

## Gesture Integration

### With Gesture Handler 2

```bash
npx expo install react-native-gesture-handler
```

```typescript
import { Gesture, GestureDetector } from 'react-native-gesture-handler';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withSpring,
} from 'react-native-reanimated';

function DraggableCard() {
  const translateX = useSharedValue(0);
  const translateY = useSharedValue(0);
  const scale = useSharedValue(1);

  const pan = Gesture.Pan()
    .onStart(() => {
      scale.value = withSpring(1.05);
    })
    .onUpdate((event) => {
      translateX.value = event.translationX;
      translateY.value = event.translationY;
    })
    .onEnd(() => {
      translateX.value = withSpring(0);
      translateY.value = withSpring(0);
      scale.value = withSpring(1);
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [
      { translateX: translateX.value },
      { translateY: translateY.value },
      { scale: scale.value },
    ],
  }));

  return (
    <GestureDetector gesture={pan}>
      <Animated.View className="bg-card rounded-xl p-6 shadow-lg" style={animatedStyle}>
        <Text className="text-card-foreground text-lg font-semibold">Drag me</Text>
      </Animated.View>
    </GestureDetector>
  );
}
```

### Swipe to delete
```typescript
function SwipeToDelete({ children, onDelete }: { children: React.ReactNode; onDelete: () => void }) {
  const translateX = useSharedValue(0);
  const itemHeight = useSharedValue(70);
  const opacity = useSharedValue(1);

  const THRESHOLD = -100;

  const pan = Gesture.Pan()
    .activeOffsetX([-10, 10])
    .onUpdate((event) => {
      translateX.value = Math.min(0, event.translationX);
    })
    .onEnd(() => {
      if (translateX.value < THRESHOLD) {
        translateX.value = withTiming(-500, { duration: 200 });
        itemHeight.value = withTiming(0, { duration: 200 });
        opacity.value = withTiming(0, { duration: 200 }, (finished) => {
          if (finished) runOnJS(onDelete)();
        });
      } else {
        translateX.value = withSpring(0);
      }
    });

  const containerStyle = useAnimatedStyle(() => ({
    height: itemHeight.value,
    opacity: opacity.value,
  }));

  const itemStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: translateX.value }],
  }));

  return (
    <Animated.View style={containerStyle}>
      <View className="absolute right-4 h-full items-center justify-center">
        <Text className="text-destructive font-bold">Delete</Text>
      </View>
      <GestureDetector gesture={pan}>
        <Animated.View className="bg-card" style={itemStyle}>
          {children}
        </Animated.View>
      </GestureDetector>
    </Animated.View>
  );
}
```

### Pinch to zoom
```typescript
function PinchableImage({ uri }: { uri: string }) {
  const scale = useSharedValue(1);
  const savedScale = useSharedValue(1);

  const pinch = Gesture.Pinch()
    .onUpdate((event) => {
      scale.value = savedScale.value * event.scale;
    })
    .onEnd(() => {
      savedScale.value = scale.value;
      if (scale.value < 1) {
        scale.value = withSpring(1);
        savedScale.value = 1;
      }
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  return (
    <GestureDetector gesture={pinch}>
      <Animated.Image
        source={{ uri }}
        className="w-full aspect-square rounded-lg"
        style={animatedStyle}
      />
    </GestureDetector>
  );
}
```

---

## Interpolation

```typescript
import { interpolate, Extrapolation } from 'react-native-reanimated';

const animatedStyle = useAnimatedStyle(() => {
  const opacity = interpolate(
    translateY.value,
    [0, 100, 200],    // input range
    [1, 0.5, 0],      // output range
    Extrapolation.CLAMP
  );

  const scale = interpolate(
    translateY.value,
    [0, 100],
    [1, 0.8],
    Extrapolation.CLAMP
  );

  return { opacity, transform: [{ scale }] };
});

// Interpolate colors
import { interpolateColor } from 'react-native-reanimated';

const animatedStyle = useAnimatedStyle(() => {
  const backgroundColor = interpolateColor(
    progress.value,
    [0, 1],
    ['#3b82f6', '#22c55e']
  );
  return { backgroundColor };
});
```

---

## Layout Animations

```typescript
import Animated, {
  FadeIn,
  FadeOut,
  FadeInDown,
  FadeInUp,
  SlideInRight,
  SlideOutLeft,
  LinearTransition,
  SequencedTransition,
} from 'react-native-reanimated';

// Enter/exit animations
<Animated.View entering={FadeInDown.duration(300).delay(100)} exiting={FadeOut}>
  <Card className="mx-4">
    <CardContent><Text>Animated card</Text></CardContent>
  </Card>
</Animated.View>

// Staggered list
{items.map((item, index) => (
  <Animated.View
    key={item.id}
    entering={FadeInDown.delay(index * 50).duration(300)}
    className="mb-2"
  >
    <Text className="text-foreground">{item.title}</Text>
  </Animated.View>
))}

// Layout transition (when items reorder/resize)
<Animated.View layout={LinearTransition.springify()}>
  {/* content that changes size */}
</Animated.View>

// Custom entering
const customEntering = () => {
  'worklet';
  const animations = {
    opacity: withTiming(1, { duration: 300 }),
    transform: [{ translateY: withSpring(0, { damping: 15 }) }],
  };
  const initialValues = {
    opacity: 0,
    transform: [{ translateY: 50 }],
  };
  return { animations, initialValues };
};

<Animated.View entering={customEntering}>
```

---

## Shared Element Transitions

```typescript
import Animated from 'react-native-reanimated';
import { SharedTransition } from 'react-native-reanimated';

// List screen
<Animated.Image
  sharedTransitionTag={`image-${item.id}`}
  source={{ uri: item.image }}
  className="w-full h-48 rounded-lg"
/>

// Detail screen
<Animated.Image
  sharedTransitionTag={`image-${id}`}
  source={{ uri: item.image }}
  className="w-full h-80"
/>
```

---

## NativeWind + Reanimated Together

### Animated.View with className
```typescript
// ✅ Combine className (static) + style (animated)
<Animated.View
  className="bg-card border border-border rounded-xl p-4 shadow-sm"
  style={animatedStyle}
>
  <Text className="text-card-foreground">Works perfectly</Text>
</Animated.View>

// className handles: colors, padding, border, rounded, shadow
// style handles: transform, opacity (animated values)
```

### Animated button press
```typescript
function AnimatedButton({ onPress, children }: { onPress: () => void; children: React.ReactNode }) {
  const scale = useSharedValue(1);

  const tap = Gesture.Tap()
    .onBegin(() => {
      scale.value = withSpring(0.95, { damping: 15, stiffness: 200 });
    })
    .onFinalize(() => {
      scale.value = withSpring(1, { damping: 15, stiffness: 200 });
    })
    .onEnd(() => {
      runOnJS(onPress)();
    });

  const animatedStyle = useAnimatedStyle(() => ({
    transform: [{ scale: scale.value }],
  }));

  return (
    <GestureDetector gesture={tap}>
      <Animated.View className="bg-primary rounded-lg px-6 py-3" style={animatedStyle}>
        <Text className="text-primary-foreground font-semibold text-center">{children}</Text>
      </Animated.View>
    </GestureDetector>
  );
}
```

---

## Expo Router Transition Animations

### Custom stack transitions
```typescript
// app/_layout.tsx
import { Stack } from 'expo-router';

<Stack screenOptions={{
  animation: 'slide_from_right',    // default
  // Other options:
  // 'slide_from_bottom' — modal-like
  // 'fade' — cross-fade
  // 'none' — instant
}}>
  <Stack.Screen name="(tabs)" />
  <Stack.Screen
    name="modal"
    options={{
      presentation: 'modal',
      animation: 'slide_from_bottom',
    }}
  />
</Stack>

// Custom animation config
<Stack.Screen
  name="details"
  options={{
    animation: 'slide_from_right',
    animationDuration: 200,
    customAnimationOnGesture: true,
  }}
/>
```

---

## Skeleton Loading Animation (NativeWind)

```typescript
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withRepeat,
  withTiming,
  interpolate,
} from 'react-native-reanimated';
import { useEffect } from 'react';

function AnimatedSkeleton({ className }: { className?: string }) {
  const shimmer = useSharedValue(0);

  useEffect(() => {
    shimmer.value = withRepeat(
      withTiming(1, { duration: 1500 }),
      -1,
      true
    );
  }, []);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: interpolate(shimmer.value, [0, 1], [0.3, 0.7]),
  }));

  return (
    <Animated.View
      className={cn("bg-muted rounded-md", className)}
      style={animatedStyle}
    />
  );
}

// Usage — card skeleton
function CardSkeleton() {
  return (
    <View className="p-4 gap-3">
      <View className="flex-row items-center gap-3">
        <AnimatedSkeleton className="w-12 h-12 rounded-full" />
        <View className="flex-1 gap-2">
          <AnimatedSkeleton className="h-4 w-3/4" />
          <AnimatedSkeleton className="h-3 w-1/2" />
        </View>
      </View>
      <AnimatedSkeleton className="h-40 w-full rounded-xl" />
      <AnimatedSkeleton className="h-4 w-full" />
      <AnimatedSkeleton className="h-4 w-2/3" />
    </View>
  );
}
```

---

## RNR Sheet Animation Hooks

```typescript
// Bottom sheet with Reanimated
import { useSharedValue, useAnimatedStyle, withSpring } from 'react-native-reanimated';
import { Gesture, GestureDetector } from 'react-native-gesture-handler';
import { Dimensions } from 'react-native';

const SCREEN_HEIGHT = Dimensions.get('window').height;
const SHEET_HEIGHT = SCREEN_HEIGHT * 0.6;

function CustomSheet({ children }: { children: React.ReactNode }) {
  const translateY = useSharedValue(SHEET_HEIGHT);
  const context = useSharedValue(0);

  const open = () => {
    translateY.value = withSpring(0, { damping: 20 });
  };

  const close = () => {
    translateY.value = withSpring(SHEET_HEIGHT, { damping: 20 });
  };

  const pan = Gesture.Pan()
    .onStart(() => {
      context.value = translateY.value;
    })
    .onUpdate((event) => {
      translateY.value = Math.max(0, context.value + event.translationY);
    })
    .onEnd((event) => {
      if (event.velocityY > 500 || translateY.value > SHEET_HEIGHT / 2) {
        close();
      } else {
        open();
      }
    });

  const sheetStyle = useAnimatedStyle(() => ({
    transform: [{ translateY: translateY.value }],
  }));

  const backdropStyle = useAnimatedStyle(() => ({
    opacity: interpolate(translateY.value, [0, SHEET_HEIGHT], [0.5, 0]),
  }));

  return (
    <>
      <Animated.View
        className="absolute inset-0 bg-black"
        style={backdropStyle}
        pointerEvents="none"
      />
      <GestureDetector gesture={pan}>
        <Animated.View
          className="absolute bottom-0 left-0 right-0 bg-card rounded-t-3xl px-4 pt-4"
          style={[{ height: SHEET_HEIGHT }, sheetStyle]}
        >
          <View className="w-12 h-1.5 bg-muted rounded-full self-center mb-4" />
          {children}
        </Animated.View>
      </GestureDetector>
    </>
  );
}
```

---

## Common Animation Presets

```typescript
// Reusable spring configs
export const SPRING = {
  snappy: { damping: 15, stiffness: 200 },
  bouncy: { damping: 8, stiffness: 100 },
  gentle: { damping: 20, stiffness: 100 },
  stiff: { damping: 20, stiffness: 300 },
} as const;

// Reusable timing configs
export const TIMING = {
  fast: { duration: 150 },
  normal: { duration: 300 },
  slow: { duration: 500 },
} as const;

// Usage
scale.value = withSpring(1.2, SPRING.snappy);
opacity.value = withTiming(0, TIMING.fast);
```
