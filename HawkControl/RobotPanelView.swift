import SwiftUI

struct RobotPanelView: View {
    @EnvironmentObject var robotConnection: GlobalStateVars
    
    var body: some View {
        VStack {
            if (robotConnection.connectedToRobot) {
                Button(action: moveForward) {
                    Label("Forward", systemImage: "arrow.up")
                }.padding()
                Button(action: moveBackward) {
                    Label("Backward", systemImage: "arrow.down")
                }.padding()
                Button(action: moveLeft) {
                    Label("Left", systemImage: "arrow.left")
                }.padding()
                Button(action: moveRight) {
                    Label("Right", systemImage: "arrow.right")
                }.padding()
            } else {
                Label("Please connect to your robot", systemImage: "exclamationmark.triangle.fill")
                    .bold()
            }
        }
    }

    func moveForward() {
        print("Move Forward")
    }

    func moveBackward() {
        print("Move Backward")
    }

    func moveLeft() {
        print("Move Left")
    }

    func moveRight() {
        print("Move Right")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RobotPanelView()
    }
}
