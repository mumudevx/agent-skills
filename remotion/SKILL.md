---
name: remotion-best-practices
description: Best practices for Remotion - Video creation in React
metadata:
  tags: remotion, video, react, animation, composition
---

## When to use

Use this skills whenever you are dealing with Remotion code to obtain the domain-specific knowledge. This includes React Native component styling and NativeWind integration within Remotion compositions.

## Captions

When dealing with captions or subtitles, load the [./rules/subtitles.md](./rules/subtitles.md) file for more information.

## Using FFmpeg

For some video operations, such as trimming videos or detecting silence, FFmpeg should be used. Load the [./rules/ffmpeg.md](./rules/ffmpeg.md) file for more information.

## Audio visualization

When needing to visualize audio (spectrum bars, waveforms, bass-reactive effects), load the [./rules/audio-visualization.md](./rules/audio-visualization.md) file for more information.

## Sound effects

When needing to use sound effects, load the [./rules/sound-effects.md](./rules/sound-effects.md) file for more information.

## How to use

Read individual rule files for detailed explanations and code examples:

- [rules/3d.md](rules/3d.md) - 3D content in Remotion using Three.js and React Three Fiber
- [rules/animations.md](rules/animations.md) - Fundamental animation skills for Remotion
- [rules/assets.md](rules/assets.md) - Importing images, videos, audio, and fonts into Remotion
- [rules/audio.md](rules/audio.md) - Using audio and sound in Remotion - importing, trimming, volume, speed, pitch
- [rules/calculate-metadata.md](rules/calculate-metadata.md) - Dynamically set composition duration, dimensions, and props
- [rules/can-decode.md](rules/can-decode.md) - Check if a video can be decoded by the browser using Mediabunny
- [rules/charts.md](rules/charts.md) - Chart and data visualization patterns for Remotion (bar, pie, line, stock charts)
- [rules/compositions.md](rules/compositions.md) - Defining compositions, stills, folders, default props and dynamic metadata
- [rules/extract-frames.md](rules/extract-frames.md) - Extract frames from videos at specific timestamps using Mediabunny
- [rules/fonts.md](rules/fonts.md) - Loading Google Fonts and local fonts in Remotion
- [rules/get-audio-duration.md](rules/get-audio-duration.md) - Getting the duration of an audio file in seconds with Mediabunny
- [rules/get-video-dimensions.md](rules/get-video-dimensions.md) - Getting the width and height of a video file with Mediabunny
- [rules/get-video-duration.md](rules/get-video-duration.md) - Getting the duration of a video file in seconds with Mediabunny
- [rules/gifs.md](rules/gifs.md) - Displaying GIFs synchronized with Remotion's timeline
- [rules/images.md](rules/images.md) - Embedding images in Remotion using the Img component
- [rules/light-leaks.md](rules/light-leaks.md) - Light leak overlay effects using @remotion/light-leaks
- [rules/lottie.md](rules/lottie.md) - Embedding Lottie animations in Remotion
- [rules/measuring-dom-nodes.md](rules/measuring-dom-nodes.md) - Measuring DOM element dimensions in Remotion
- [rules/measuring-text.md](rules/measuring-text.md) - Measuring text dimensions, fitting text to containers, and checking overflow
- [rules/sequencing.md](rules/sequencing.md) - Sequencing patterns for Remotion - delay, trim, limit duration of items
- [rules/tailwind.md](rules/tailwind.md) - Using TailwindCSS in Remotion
- [rules/text-animations.md](rules/text-animations.md) - Typography and text animation patterns for Remotion
- [rules/timing.md](rules/timing.md) - Interpolation curves in Remotion - linear, easing, spring animations
- [rules/transitions.md](rules/transitions.md) - Scene transition patterns for Remotion
- [rules/transparent-videos.md](rules/transparent-videos.md) - Rendering out a video with transparency
- [rules/trimming.md](rules/trimming.md) - Trimming patterns for Remotion - cut the beginning or end of animations
- [rules/videos.md](rules/videos.md) - Embedding videos in Remotion - trimming, volume, speed, looping, pitch
- [rules/parameters.md](rules/parameters.md) - Make a video parametrizable by adding a Zod schema
- [rules/maps.md](rules/maps.md) - Add a map using Mapbox and animate it
- [rules/voiceover.md](rules/voiceover.md) - Adding AI-generated voiceover to Remotion compositions using ElevenLabs TTS

## React Native

When working with React Native components in Remotion compositions, load the relevant rule files:

- [rules/react-native/core-components.md](rules/react-native/core-components.md) - View, Text, Image, ScrollView usage in Remotion compositions
- [rules/react-native/styling.md](rules/react-native/styling.md) - StyleSheet.create, inline styles, style prop in Remotion video render
- [rules/react-native/flexbox-layout.md](rules/react-native/flexbox-layout.md) - Flexbox layout patterns for video composition sizing and positioning
- [rules/react-native/typography.md](rules/react-native/typography.md) - Text component, font loading, text measurement in Remotion
- [rules/react-native/images-media.md](rules/react-native/images-media.md) - Image component, video/audio assets — RN vs web Remotion comparison
- [rules/react-native/platform-specific.md](rules/react-native/platform-specific.md) - Platform.OS, platform selectors, safe area in video render context
- [rules/react-native/performance.md](rules/react-native/performance.md) - React.memo, useMemo, useCallback for video rendering optimizations
- [rules/react-native/animations-integration.md](rules/react-native/animations-integration.md) - Why Reanimated must NOT be used — use Remotion's animation system instead

## NativeWind

When using NativeWind for styling Remotion components, load the relevant rule files:

- [rules/nativewind/setup.md](rules/nativewind/setup.md) - NativeWind + Remotion project configuration (metro, babel, tailwind)
- [rules/nativewind/classname-patterns.md](rules/nativewind/classname-patterns.md) - className prop usage, cn() helper, conditional classes in Remotion
- [rules/nativewind/theming.md](rules/nativewind/theming.md) - CSS variables, design tokens, dark mode for video theme system
- [rules/nativewind/responsive.md](rules/nativewind/responsive.md) - Breakpoints and responsive layout for different video resolutions
- [rules/nativewind/states-interactions.md](rules/nativewind/states-interactions.md) - Interactive states in video context — use useCurrentFrame instead
- [rules/nativewind/typography-spacing.md](rules/nativewind/typography-spacing.md) - Text classes, spacing system, gap for video composition typography
- [rules/nativewind/borders-shadows.md](rules/nativewind/borders-shadows.md) - Border, rounded, shadow utilities for video element visual effects
- [rules/nativewind/common-mistakes.md](rules/nativewind/common-mistakes.md) - Common pitfalls: StyleSheet + className mixing, Tailwind animations, className forwarding
