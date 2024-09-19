//
//  CrescendoFieldView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 9/3/24.
//

import SwiftUI

struct CrescendoFieldView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("CrescendoField") // Use the name of your image asset
                .resizable()
                .aspectRatio(contentMode: .fit) // Fit the image within the view's bounds
                .frame(width: geometry.size.width, height: geometry.size.height) // Make it fill the view
                .overlay(
                    DrawingOverlay() // This is where your drawing functionality would go
                )
        }
    }
}

struct DrawingOverlay: View {
    @State private var path = Path()
    @State private var currentPoint: CGPoint?

    var body: some View {
        path.stroke(Color.blue, lineWidth: 4)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if let lastPoint = currentPoint {
                        path.addLine(to: value.location)
                    } else {
                        path.move(to: value.location)
                    }
                    currentPoint = value.location
                }
                .onEnded { _ in
                    currentPoint = nil
                }
            )
    }
}

struct CrescendoFieldView_Previews: PreviewProvider {
    static var previews: some View {
        CrescendoFieldView()
    }
}
