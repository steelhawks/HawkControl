    import SwiftUI
    import Starscream

    class WebSocketDelegateImpl: WebSocketDelegate, ObservableObject {
        @Published var isConnected: Bool = false

        func didReceive(event: WebSocketEvent, client: WebSocketClient) {
            switch event {
                case .connected(let headers):
                    print("WebSocket is connected: \(headers)")
                    DispatchQueue.main.async {
                        self.isConnected = true
                    }
                case .disconnected(let reason, let code):
                    print("WebSocket is disconnected: \(reason) with code: \(code)")
                    DispatchQueue.main.async {
                        self.isConnected = false
                    }
                case .text(let string):
                    print("Received text: \(string)")
                case .binary(let data):
                    print("Received data: \(data.count)")
                case .ping(_):
                    break
                case .pong(_):
                    break
                case .viabilityChanged(_):
                    break
                case .reconnectSuggested(_):
                    break
                case .cancelled:
                    DispatchQueue.main.async {
                        self.isConnected = false
                    }
                case .error(let error):
                    print("Error: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.isConnected = false
                    }
            case .peerClosed:
                print("WebSocket peer closed")
                DispatchQueue.main.async {
                    self.isConnected = false
                }
            @unknown default:
                    print("Unknown event received")
            }
        }
    }

    class WebSocketManager: ObservableObject {
        var socket: WebSocket?
        
        @Published var delegate: WebSocketDelegateImpl = WebSocketDelegateImpl()

        func connect(ip: String, port: String) {
            var request = URLRequest(url: URL(string: "ws://\(ip):\(port)")!)
            request.timeoutInterval = 5
            socket = WebSocket(request: request)
            if (socket != nil) {
                socket?.delegate = delegate // ?
                socket?.connect() // ?
            } else {
                print("NIL")
            }
        }

        func disconnect() {
            socket?.disconnect() // ?
        }

        func sendData(key: String, value: String) {
            let message = "{\"\(key)\": \"\(value)\"}"
            
            if (socket != nil) {
                socket?.write(string: message) // ?
            } else {
                print("THIS IS NIL WHEN SENDING COMMAND")
            }

            print("Sent data to server: \(message)")
        }
    }

    struct ConnectView: View {
        @EnvironmentObject var robotConnection: GlobalStateVars
        @StateObject var webSocketManager = WebSocketManager()
        @State private var ip: String = "192.168.1.175" // dev ip
        @State private var port: String = "8766" // WebSocket port

        @State private var showingAlert = false
        @State private var includeSecondary = false
        @State private var alertTitle = ""
        @State private var alertText = ""
        @State private var primaryButtonText = ""

        func showAlert(title: String, message: String, primaryButton: String?, includeSecondary: Bool) {
            alertTitle = title
            alertText = message
            primaryButtonText = primaryButton ?? "OK"
            self.includeSecondary = includeSecondary
            showingAlert = true
        }
        
        func sendValue(key: String, value: String) {
            webSocketManager.sendData(key: key, value: value)
        }
        

        func connectToRobot() {
            if ip.isEmpty || port.isEmpty {
                showAlert(title: "Failed to Connect to Robot",
                          message: "Failed to connect because either IP or PORT is blank",
                          primaryButton: nil,
                          includeSecondary: false)
                return
            }

            webSocketManager.connect(ip: ip, port: port)
            // wait half a second b/c delgate takes time sometimes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                robotConnection.connectedToRobot = self.webSocketManager.delegate.isConnected
            }
        }

        func disconnectFromRobot() {
            webSocketManager.disconnect()
            robotConnection.connectedToRobot = false
        }

        var body: some View {
            HStack {
                VStack {
                    Image(systemName: !robotConnection.connectedToRobot ? "network.slash" : "network")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Robot Status: " + (robotConnection.connectedToRobot ? "Connected" : "Disconnected")).bold()
                    HStack(alignment: .center) {
                        TextField("IP", text: $ip)
                            .frame(width: 150.0, height: 50.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("PORT", text: $port)
                            .frame(width: 100.0, height: 50.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                    }
                    if !robotConnection.connectedToRobot {
                        Button(action: connectToRobot) {
                            Label("Connect To Robot", systemImage: "arrow.up")
                        }.padding(5)
                    } else {
                        Button(action: disconnectFromRobot) {
                            Label("Disconnect From Robot", systemImage: "arrow.down")
                        }.padding(5)
                        Button(action: {
                            sendValue(key: "dir", value: "1.0")
                        }) {
                            Label("Up", systemImage: "arrow.up")
                        }.padding(5)
                        Button(action: {
                            sendValue(key: "dir", value: "-1.0")
                        }) {
                            Label("Down", systemImage: "arrow.down")
                        }.padding(5)
                        Button(action: {
                            sendValue(key: "rot", value: "1.0")
                        }) {
                            Label("Left", systemImage: "arrow.left")
                        }.padding(5)
                        Button(action: {
                            sendValue(key: "rot", value: "-1.0")
                        }) {
                            Label("Right", systemImage: "arrow.right")
                        }.padding(5)
                        Button(action: {
                            sendValue(key: "dir", value: "0.0")
                            sendValue(key: "rot", value: "0.0")
                        }) {
                            Label("Stop", systemImage: "xmark")
                        }.padding(5)




                    }
                }.padding(.all, 20)
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text(alertTitle),
                            message: Text(alertText),
                            dismissButton: .default(Text(primaryButtonText))
                        )
                    }
            }.padding()
        }
    }

    #Preview {
        ConnectView().environmentObject(GlobalStateVars())
    }
