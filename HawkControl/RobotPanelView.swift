import SwiftUI

struct RobotPanelView: View {
    @EnvironmentObject var robotConnection: GlobalStateVars
    @EnvironmentObject var webSocketManager: WebSocketManager // Inject WebSocketManager here

    var body: some View {
        VStack {
            if robotConnection.connectedToRobot {
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
        webSocketManager.sendData(key: "dir", value: "1.0")
    }

    func moveBackward() {
        print("Move Backward")
        webSocketManager.sendData(key: "dir", value: "-1.0")
    }

    func moveLeft() {
        print("Move Left")
        webSocketManager.sendData(key: "rot", value: "1.0")
    }

    func moveRight() {
        print("Move Right")
        webSocketManager.sendData(key: "rot", value: "-1.0")
    }
}

struct RobotPanelView_Previews: PreviewProvider {
    static var previews: some View {
        RobotPanelView()
//        let webSocketManager = WebSocketManager() // Initialize WebSocketManager
//        return RobotPanelView(webSocketManager: webSocketManager).environmentObject(GlobalStateVars())
    }
}
