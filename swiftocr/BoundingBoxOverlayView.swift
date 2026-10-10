//
//  BoundingBoxOverlayView.swift
//  MyApp
//
//  Created by Abanoub on 10/10/2026.
//

import SwiftUI

struct BoundingBoxOverlayView: View {
    let imageSize: CGSize
    let blocks: [OCRBlock]

    var body: some View {
        GeometryReader { geometry in
            let containerSize = geometry.size
            
            // Calculate actual aspect-fit frame of image within container
            let scale = min(
                containerSize.width / imageSize.width,
                containerSize.height / imageSize.height
            )
            let fitWidth = imageSize.width * scale
            let fitHeight = imageSize.height * scale
            let offsetX = (containerSize.width - fitWidth) / 2
            let offsetY = (containerSize.height - fitHeight) / 2

            ZStack {
                ForEach(blocks) { block in
                    let rect = convertVisionRect(
                        block.boundingBox,
                        fitWidth: fitWidth,
                        fitHeight: fitHeight,
                        offsetX: offsetX,
                        offsetY: offsetY
                    )

                    Rectangle()
                        .path(in: rect)
                        .stroke(Color.accentColor, lineWidth: 1.5)
                        .background(
                            Rectangle()
                                .path(in: rect)
                                .fill(Color.accentColor.opacity(0.15))
                        )
                }
            }
        }
    }

    /// Converts Vision normalized box (bottom-left origin) to SwiftUI screen rect (top-left origin)
    private func convertVisionRect(
        _ visionRect: CGRect,
        fitWidth: CGFloat,
        fitHeight: CGFloat,
        offsetX: CGFloat,
        offsetY: CGFloat
    ) -> CGRect {
        let x = offsetX + (visionRect.origin.x * fitWidth)
        // Invert Y axis: Vision 0 is bottom, SwiftUI 0 is top
        let y = offsetY + ((1.0 - visionRect.origin.y - visionRect.height) * fitHeight)
        let width = visionRect.width * fitWidth
        let height = visionRect.height * fitHeight

        return CGRect(x: x, y: y, width: width, height: height)
    }
}
