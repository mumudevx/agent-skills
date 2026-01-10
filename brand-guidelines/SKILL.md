---
name: brand-guidelines
description: Applies Reiso's official brand colors and typography to any sort of artifact that may benefit from having Reiso's look-and-feel. Use it when brand colors or style guidelines, visual formatting, or company design standards apply.
---

# Reiso Brand Styling

## Overview

To access Reiso's official brand identity and style resources, use this skill.

**Keywords**: branding, corporate identity, visual identity, post-processing, styling, brand colors, typography, Reiso brand, visual formatting, visual design

## Brand Guidelines

### Colors

**Main Colors:**

- Dark: `#1A1A1A` - Primary text and dark backgrounds
- Light: `#F8F8F8` - Light backgrounds and text on dark
- Mid Gray: `#6B7280` - Secondary elements
- Light Gray: `#D1D5DB` - Subtle backgrounds

**Accent Colors:**

- Purple: `#2A3170` - Primary accent
- Green: `#86EFAC` - Secondary accent

### Typography

- **Headings**: Plus Jakarta Sans (Sans-Serif) (with Arial fallback)
- **Body Text**: Inter (Sans-Serif) (with Georgia fallback)
- **Note**: Fonts should be pre-installed in your environment for best results

## Features

### Smart Font Application

- Applies Plus Jakarta Sans font to headings (24pt and larger)
- Applies Inter font to body text
- Automatically falls back to Arial/Georgia if custom fonts unavailable
- Preserves readability across all systems

### Text Styling

- Headings (24pt+): Plus Jakarta Sans font
- Body text: Inter font
- Smart color selection based on background
- Preserves text hierarchy and formatting

### Shape and Accent Colors

- Non-text shapes use accent colors
- Cycles through orange, blue, and green accents
- Maintains visual interest while staying on-brand

## Technical Details

### Font Management

- Uses system-installed Plus Jakarta Sans and Inter fonts when available
- Provides automatic fallback to Arial (headings) and Georgia (body)
- No font installation required - works with existing system fonts
- For best results, pre-install Plus Jakarta Sans and Inter fonts in your environment

### Color Application

- Uses RGB color values for precise brand matching
- Applied via python-pptx's RGBColor class
- Maintains color fidelity across different systems
