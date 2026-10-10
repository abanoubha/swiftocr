# SwiftOCR

`SwiftOCR` is a native macOS desktop application built with **SwiftUI** and Apple's **Vision framework** that performs real-time on-device Optical Character Recognition (OCR).

## Features

- **On-Device Machine Learning:** Powered by Apple Vision (`VNRecognizeTextRequest`) — zero external dependencies or cloud APIs required.
- **Bilingual OCR:** Native recognition for English and Arabic (`ar-SA`) scripts, including complex script alignment and diacritics.
- **Dynamic Language Selection:** Switch between *Auto Detect*, *Arabic & English*, *Arabic Only*, and *English Only* modes.
- **Visual Bounding Box Overlays:** Renders detected text block bounding boxes scaled over the source image.
- **Interactive Hover Sync:** Hovering over a bounding box highlights the corresponding text line in the sidebar list (and vice versa).
- **Drag-and-Drop Interface:** Drop any image directly onto the app workspace or select via `NSOpenPanel`.

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 14.0+

## Building from Source

1. Clone this repository:
   ```bash
   git clone https://github.com/abanoubha/swiftocr.git
   ```

