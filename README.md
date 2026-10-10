# SwiftOCR

**SwiftOCR** is a fast, native macOS desktop application built with **SwiftUI** and Apple's **Vision Framework**. It performs real-time, on-device Optical Character Recognition (OCR) with zero external dependencies, cloud APIs, or third-party wrappers.

Designed with full support for complex scripts, SwiftOCR provides dynamic language detection, bilingual Arabic and English extraction, interactive bounding box visual overlays, and synchronized text highlighting.

---

## Features

- ⚡ **Native On-Device Neural Engine:** Leverages Apple Vision (`VNRecognizeTextRequestRevision3`) for fast, local text extraction with complete offline privacy.
- 🌐 **Full Arabic & English OCR:** Seamless recognition for Modern Standard Arabic (`ar-SA`) and English (`en-US`), featuring accurate diacritic processing and complex script handling.
- 🔄 **Dynamic Language Modes:** Easily toggle between **Auto Detect**, **Arabic & English**, **Arabic Only**, and **English Only** modes from the toolbar.
- 📐 **Visual Bounding Box Overlay:** Renders scalable overlays for detected text lines directly on top of the source image using normalized vision coordinates.
- 🎯 **Interactive Hover Synchronization:** Hovering over a bounding box on the image highlights the corresponding line in the text panel (and vice versa) with smooth auto-scrolling.
- 📑 **Native RTL Layout Engine:** Automatically detects right-to-left (RTL) unicode characters and adjusts text direction and alignment accordingly.
- 📥 **Drag-and-Drop & File Picker:** Drop images directly onto the app workspace or browse via `NSOpenPanel`.

---

## User Interface


```text

+------------------------------------------+------------------------------------------+
|  Image Dropzone & Bounding Overlay       |  Recognized Text & Control Toolbar       |
|                                          |                                          |
|  +------------------------------------+  |  [ Language: Auto Detect ▼ ] [ Copy ]   |
|  |                                    |  |  +------------------------------------+  |
|  |   [ Source Image Display ]         |  |  | 1. Recognized line of text...     |  |
|  |   ┌────────────────────────────┐   |  |  | 2. النص العربي المشروح هنا         |  |
|  |   │ Bounding Box Overlay Line  │   |  |  | 3. Third line entry...            |  |
|  |   └────────────────────────────┘   |  |  +------------------------------------+  |
|  +------------------------------------+  |                                          |
|  [ Select Image... ]   [ Clear ]         |  Active Line Sync & Line Selection       |
+------------------------------------------+------------------------------------------+

```

---

## System Requirements

- **Operating System:** macOS 13.0 (Ventura) or later
- **Architecture:** Apple Silicon (M1/M2/M3/M4) or Intel x86_64
- **Development Tooling:** Xcode 14.0+ (Swift 5.7+)

---

## Architecture & Frameworks

| Component | Technology | Role |
| :--- | :--- | :--- |
| **User Interface** | `SwiftUI` | Split-view layout (`HSplitView`), dynamic frame layout, coordinate conversion (`GeometryReader`), scroll management (`ScrollViewReader`) |
| **OCR Engine** | `Vision` Framework | Asynchronous on-device text recognition (`VNRecognizeTextRequest`) |
| **System Integration** | `AppKit` | Native image representations (`NSImage`), native file system pickers (`NSOpenPanel`), clipboard handling (`NSPasteboard`) |

---

## Getting Started

### Prerequisites

Ensure you have Xcode installed from the Mac App Store or [Apple Developer Portal](https://developer.apple.com).

### Building from Source

1. **Clone the repository:**
```bash
git clone https://github.com/abanoubha/SwiftOCR.git
cd SwiftOCR
```

2. **Open in Xcode:**
```bash
open SwiftOCR.xcodeproj

```

3. **Build & Run:**
* Select **SwiftOCR > My Mac** in the top destination scheme menu.
* Press `⌘R` to compile and launch the application.

---

## Usage Guide

1. **Import Image:** Drag and drop an image (PNG, JPEG, WebP) onto the left pane, or click **Select Image...**.
2. **Select Language:** Choose your desired language detection model from the **Language** menu picker.
3. **Inspect Text:** View recognized lines on the right. Hover over any text block on the image or list entry to highlight the corresponding region.
4. **Copy Output:** Click **Copy Text** to copy the full recognized string to the macOS clipboard.

---

## Project Structure

```text
SwiftOCR/
├── SwiftOCR/
│   ├── App/
│   │   └── SwiftOCRApp.swift                 # Application Entry Point
│   ├── Models/
│   │   ├── OCRBlock.swift                    # Bounding Box & Line Data Model
│   │   └── OCRLanguage.swift                 # Language Configuration Enum
│   ├── Services/
│   │   └── OCREngine.swift                   # Vision Framework Asynchronous Engine
│   └── Views/
│       ├── ContentView.swift                 # Split-Pane Layout Container
│       ├── HoverableBoundingBoxOverlay.swift # Interactive Coordinate Mapping Overlay
│       └── OCRTextListView.swift             # Hover-Synchronized Text Sidebar
├── SwiftOCR.xcodeproj                        # Xcode Project Bundle
├── .gitignore                                # macOS & Xcode System Exclusions
├── LICENSE                                   # License File
└── README.md                                 # Project Documentation

```

---

## Contributing

Contributions are welcome! If you'd like to report a bug or suggest a feature, please open an issue or submit a pull request:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feature:add some amazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## License

Distributed under the MIT License.

