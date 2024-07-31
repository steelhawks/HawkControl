import SwiftUI
import Combine

class GlobalStateVars: ObservableObject {
    static let shared = GlobalStateVars()
    
    @Published var connectedToRobot: Bool = false
    
    // robot statuses
    @Published var robotState: String = ""
    @Published var noteStatus: String = ""
    @Published var isReadyToShoot: String = ""
    
    // settings
    @Published var useGyroForControl: Bool = false
}
