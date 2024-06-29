import SwiftUI
import Combine

class GlobalStateVars: ObservableObject {
    @Published var connectedToRobot: Bool = false
}
