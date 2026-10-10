//
//  OCREngine.swift
//  MyApp
//
//  Created by Abanoub on 10/10/2026.
//

import Foundation
import Vision
import AppKit

struct OCRBlock: Identifiable {
    let id = UUID()
    let text: String
    /// Bounding box normalized [0...1] relative to bottom-left origin
    let boundingBox: CGRect
}

struct OCRResult {
    let fullText: String
    let blocks: [OCRBlock]
}

enum OCRLanguage: String, CaseIterable, Identifiable {
    case auto = "Auto Detect"
    case arabicAndEnglish = "Arabic & English"
    case arabic = "Arabic Only"
    case english = "English Only"

    var id: String { rawValue }

    var languageCodes: [String] {
        switch self {
        case .auto, .arabicAndEnglish:
            return ["ar-SA", "en-US"]
        case .arabic:
            return ["ar-SA"]
        case .english:
            return ["en-US"]
        }
    }

    var autoDetectEnabled: Bool {
        return self == .auto
    }
}

struct OCREngine {
    static func recognizeText(
        from image: NSImage,
        languageMode: OCRLanguage,
        completion: @escaping (Result<OCRResult, Error>) -> Void
    ) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            let error = NSError(
                domain: "OCREngine",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to derive CGImage representation."]
            )
            completion(.failure(error))
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(.success(OCRResult(fullText: "", blocks: [])))
                return
            }

            let blocks = observations.compactMap { obs -> OCRBlock? in
                guard let topCandidate = obs.topCandidates(1).first else { return nil }
                return OCRBlock(text: topCandidate.string, boundingBox: obs.boundingBox)
            }

            let fullText = blocks.map { $0.text }.joined(separator: "\n")
            completion(.success(OCRResult(fullText: fullText, blocks: blocks)))
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.revision = VNRecognizeTextRequestRevision3
        request.recognitionLanguages = languageMode.languageCodes

        if #available(macOS 13.0, *) {
            request.automaticallyDetectsLanguage = languageMode.autoDetectEnabled
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}
