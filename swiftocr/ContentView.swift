import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedImage: NSImage?
    @State private var extractedText: String = ""
    @State private var detectedBlocks: [OCRBlock] = []
    @State private var hoveredBlockID: UUID?
    @State private var isProcessing: Bool = false
    @State private var isTargeted: Bool = false
    @State private var selectedLanguage: OCRLanguage = .auto

    var body: some View {
        HSplitView {
            // Left Pane: Image Input + Hoverable Overlay
            VStack(spacing: 16) {
                if let image = selectedImage {
                    ZStack {
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()

                        HoverableBoundingBoxOverlay(
                            imageSize: image.size,
                            blocks: detectedBlocks,
                            hoveredBlockID: $hoveredBlockID
                        )
                    }
                    .frame(maxHeight: .infinity)
                    .cornerRadius(8)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Drag & drop an image here\nor click below to browse")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                            .foregroundColor(isTargeted ? .accentColor : .secondary.opacity(0.4))
                    )
                }

                HStack(spacing: 12) {
                    Button("Select Image...") {
                        openFilePicker()
                    }

                    if selectedImage != nil {
                        Button("Clear") {
                            selectedImage = nil
                            extractedText = ""
                            detectedBlocks = []
                            hoveredBlockID = nil
                        }
                    }
                }
            }
            .padding()
            .frame(minWidth: 340, minHeight: 450)
            .onDrop(of: [.image], isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers)
            }

            // Right Pane: Output List with Synchronized Hovering
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Recognized Text")
                        .font(.headline)

                    Spacer()

                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(OCRLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                    .pickerStyle(.menu)
                    .fixedSize()

                    if isProcessing {
                        ProgressView()
                            .controlSize(.small)
                    }

                    Button("Copy Text") {
                        copyToClipboard(extractedText)
                    }
                    .disabled(extractedText.isEmpty || isProcessing)
                }

                if detectedBlocks.isEmpty && !extractedText.isEmpty {
                    Text(extractedText)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                } else {
                    OCRTextListView(blocks: detectedBlocks, hoveredBlockID: $hoveredBlockID)
                }
            }
            .padding()
            .frame(minWidth: 360, minHeight: 450)
        }
        .frame(minWidth: 740, minHeight: 480)
        .onChange(of: selectedLanguage) { _, _ in
            if let image = selectedImage {
                processImage(image)
            }
        }
    }

    private func openFilePicker() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK, let url = panel.url, let image = NSImage(contentsOf: url) {
            processImage(image)
        }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, _ in
            if let data = data, let image = NSImage(data: data) {
                DispatchQueue.main.async {
                    processImage(image)
                }
            }
        }
        return true
    }

    private func processImage(_ image: NSImage) {
        self.selectedImage = image
        self.isProcessing = true
        self.extractedText = ""
        self.detectedBlocks = []
        self.hoveredBlockID = nil

        OCREngine.recognizeText(from: image, languageMode: selectedLanguage) { result in
            DispatchQueue.main.async {
                self.isProcessing = false
                switch result {
                case .success(let ocrResult):
                    self.extractedText = ocrResult.fullText.isEmpty ? "No text detected in image." : ocrResult.fullText
                    self.detectedBlocks = ocrResult.blocks
                case .failure(let error):
                    self.extractedText = "OCR Error: \(error.localizedDescription)"
                }
            }
        }
    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}
