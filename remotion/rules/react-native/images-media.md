---
name: images-media
description: Image component, video and audio assets — React Native vs web Remotion comparison
metadata:
  tags: react-native, remotion, image, video, audio, media, assets
---

## Images and Media in Remotion with React Native

Handling images, video, and audio in Remotion requires using Remotion-specific components for frame-accurate rendering. React Native's `Image` component can work but has limitations in the rendering pipeline.

### Image Components

- **Web Remotion (default):** Use `<Img>` from `remotion` for frame-accurate image rendering.
- **React Native context:** `Image` from `react-native` can be used, but `<Img>` from Remotion is preferred because it integrates with `delayRender` for guaranteed loading before frame capture.
- **expo-image** is **NOT compatible** with Remotion's rendering pipeline. Do not use it.

### Asset Sources

Use `staticFile()` for local assets placed in the `public/` directory. Use URL strings for remote assets.

```tsx
import { staticFile } from "remotion";

// Local asset
const localSrc = staticFile("images/logo.png");

// Remote asset
const remoteSrc = "https://example.com/photo.jpg";
```

### Image Loading with delayRender

Use the `delayRender` / `continueRender` pattern to ensure images are fully loaded before Remotion captures the frame. This prevents blank or partially loaded images in the rendered video.

```tsx
import { useCallback, useState } from "react";
import {
  Img,
  staticFile,
  delayRender,
  continueRender,
  useCurrentFrame,
  interpolate,
  AbsoluteFill,
} from "remotion";

export const ImageComposition: React.FC = () => {
  const frame = useCurrentFrame();
  const [handle] = useState(() => delayRender("Loading image"));

  const onImageLoad = useCallback(() => {
    continueRender(handle);
  }, [handle]);

  const scale = interpolate(frame, [0, 60], [1.2, 1], {
    extrapolateRight: "clamp",
  });

  return (
    <AbsoluteFill style={{ backgroundColor: "#000" }}>
      <Img
        src={staticFile("images/background.jpg")}
        onLoad={onImageLoad}
        style={{
          width: "100%",
          height: "100%",
          objectFit: "cover",
          transform: `scale(${scale})`,
        }}
      />
      <AbsoluteFill
        style={{ justifyContent: "center", alignItems: "center" }}
      >
        <h1 style={{ color: "white", fontSize: 64 }}>
          Frame {frame}
        </h1>
      </AbsoluteFill>
    </AbsoluteFill>
  );
};
```

### Video and Audio

Use Remotion's `<Video>` and `<Audio>` components for frame-accurate media playback. These components sync media playback to the current frame.

```tsx
import { Video, Audio, staticFile, AbsoluteFill } from "remotion";

export const MediaComposition: React.FC = () => {
  return (
    <AbsoluteFill>
      <Video src={staticFile("videos/clip.mp4")} />
      <Audio src={staticFile("audio/bgm.mp3")} volume={0.5} />
    </AbsoluteFill>
  );
};
```

### Key Rules

- Prefer `<Img>` from Remotion over `Image` from React Native for frame-accurate loading.
- Never use `expo-image` in Remotion compositions.
- Use `staticFile()` for local assets in the `public/` directory.
- Always use `delayRender` / `continueRender` for async image loading.
- Use Remotion's `<Video>` and `<Audio>` components, not React Native media libraries.
