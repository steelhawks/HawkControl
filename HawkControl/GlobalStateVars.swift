import SwiftUI
import Combine

class GlobalStateVars: ObservableObject {
    static let shared = GlobalStateVars()
    
    @Published var connectedToRobot: Bool = false
    
    // settings
    @Published var useGyroForControl: Bool = false
}
