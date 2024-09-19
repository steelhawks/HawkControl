//
//  FieldView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 9/3/24.
//

import SwiftUI
import PencilKit

struct FieldView: View {
    @ObservedObject var stateVars: GlobalStateVars = GlobalStateVars.shared
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    // Field Image
                    Image("CrescendoField")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .allowsHitTesting(false)

                    // CanvasView from PencilKit
                    CanvasView()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            
            // Display the current alliance
            Text("Current alliance: \(stateVars.alliance)")
                .padding()
        }
    }
}

#Preview {
    FieldView()
}
