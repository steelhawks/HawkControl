//
//  CanvasView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 9/4/24.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .blue, width: 5)
        canvasView.backgroundColor = .clear // Make sure it's transparent to see the field image
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update the canvas view if needed
    }
}
