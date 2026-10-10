//
//  OCRTextListView.swift
//  MyApp
//
//  Created by Abanoub on 10/10/2026.
//

import Foundation
import SwiftUI

struct OCRTextListView: View {
    let blocks: [OCRBlock]
    @Binding var hoveredBlockID: UUID?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(blocks) { block in
                        let isHovered = (block.id == hoveredBlockID)

                        Text(block.text)
                            .font(.system(.body, design: .monospaced))
                            .environment(\.layoutDirection, containsArabic(block.text) ? .rightToLeft : .leftToRight)
                            .frame(maxWidth: .infinity, alignment: containsArabic(block.text) ? .trailing : .leading)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(isHovered ? Color.accentColor.opacity(0.2) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(isHovered ? Color.accentColor : Color.clear, lineWidth: 1)
                            )
                            .id(block.id)
                            .onHover { hovering in
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    hoveredBlockID = hovering ? block.id : (hoveredBlockID == block.id ? nil : hoveredBlockID)
                                }
                            }
                    }
                }
                .padding(8)
            }
            .onChange(of: hoveredBlockID) { _, newID in
                if let targetID = newID {
                    withAnimation {
                        proxy.scrollTo(targetID, anchor: .center)
                    }
                }
            }
        }
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }

    private func containsArabic(_ text: String) -> Bool {
        return text.unicodeScalars.contains { scalar in
            (0x0600...0x06FF).contains(scalar.value) ||
            (0x0750...0x077F).contains(scalar.value)
        }
    }
}
