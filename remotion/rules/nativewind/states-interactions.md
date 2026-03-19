---
name: states-interactions
description: Active, disabled, focus, and group states for interactive video elements
metadata:
  tags: nativewind, remotion, states, interactions, group, hover, focus, disabled
---

## States and Interactions in Remotion Compositions

In video rendering, interactive states like `hover`, `focus`, and `active` are NOT applicable — there is no user interaction during a rendered video. These states are only relevant for Remotion Player UI components in preview mode. For "state-like" visual changes in video, use `useCurrentFrame()` with conditional classes.

### Frame-Based State Changes

Replace interactive states with frame-based logic using `useCurrentFrame()`. Toggle classes conditionally to simulate state transitions within the video timeline.

```tsx
import { useCurrentFrame } from "remotion";
import { View, Text } from "react-native";

export const StateDemo: React.FC = () => {
  const frame = useCurrentFrame();
  const isHighlighted = frame >= 30 && frame < 90;

  return (
    <View className="flex-1 items-center justify-center bg-gray-900">
      <View className={`rounded-xl p-6 ${isHighlighted ? "bg-blue-500" : "bg-gray-700"}`}>
        <Text className={`text-xl font-semibold ${isHighlighted ? "text-white" : "text-gray-400"}`}>
          {isHighlighted ? "Active" : "Inactive"}
        </Text>
      </View>
    </View>
  );
};
```

### Group States for Parent-Child Styling

NativeWind's `group` modifier can be used for static parent-child styling relationships. In video context, this is purely structural — not interactive.

```tsx
import { View, Text } from "react-native";

export const GroupExample: React.FC = () => {
  return (
    <View className="flex-1 items-center justify-center bg-slate-900">
      <View className="group rounded-2xl bg-slate-800 p-8">
        <Text className="text-2xl font-bold text-white group-[]:mb-2">
          Card Title
        </Text>
        <Text className="text-base text-slate-400">
          Card description text
        </Text>
      </View>
    </View>
  );
};
```

### Disabled Visual State

Use disabled-style classes to create greyed-out visual indicators without actual interactivity.

```tsx
import { useCurrentFrame } from "remotion";
import { View, Text } from "react-native";

export const DisabledVisual: React.FC = () => {
  const frame = useCurrentFrame();
  const isEnabled = frame >= 45;

  return (
    <View className="flex-1 items-center justify-center bg-gray-950">
      <View
        className={`rounded-lg px-8 py-4 ${
          isEnabled ? "bg-blue-500" : "bg-gray-600 opacity-50"
        }`}
      >
        <Text
          className={`text-lg font-semibold ${
            isEnabled ? "text-white" : "text-gray-400"
          }`}
        >
          {isEnabled ? "Submit" : "Disabled"}
        </Text>
      </View>
    </View>
  );
};
```

### Sequential State Transitions

Simulate multiple state transitions across the video timeline by mapping frame ranges to visual states.

```tsx
import { useCurrentFrame } from "remotion";
import { View, Text } from "react-native";

type ItemState = "idle" | "active" | "completed";

function getState(frame: number, startFrame: number): ItemState {
  if (frame < startFrame) return "idle";
  if (frame < startFrame + 30) return "active";
  return "completed";
}

const stateStyles: Record<ItemState, { container: string; text: string }> = {
  idle: { container: "bg-gray-700 border-gray-600", text: "text-gray-400" },
  active: { container: "bg-blue-600 border-blue-400", text: "text-white" },
  completed: { container: "bg-green-600 border-green-400", text: "text-white" },
};

export const SequentialStates: React.FC = () => {
  const frame = useCurrentFrame();

  const items = [0, 30, 60].map((start, i) => {
    const state = getState(frame, start);
    const styles = stateStyles[state];
    return (
      <View key={i} className={`rounded-lg border-2 px-6 py-3 ${styles.container}`}>
        <Text className={`text-lg font-medium ${styles.text}`}>
          Step {i + 1}: {state}
        </Text>
      </View>
    );
  });

  return (
    <View className="flex-1 items-center justify-center gap-4 bg-gray-950">
      {items}
    </View>
  );
};
```

### Key Points

- Interactive states (`hover`, `focus`, `active`) do NOT apply in rendered video output.
- These states only work in Remotion Player UI components during preview.
- Use `useCurrentFrame()` with conditional classes for visual state changes in video.
- `group` modifier works for static parent-child styling, not interactive behavior.
- Map frame ranges to visual states for sequential transition effects.
