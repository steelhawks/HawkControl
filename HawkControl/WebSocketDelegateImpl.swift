//
//  WebSocketDelegateImpl.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/29/24.
//

import Starscream

class WebSocketDelegateImpl: WebSocketDelegate, ObservableObject {
    var stateVars: GlobalStateVars = GlobalStateVars.shared

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
            case .connected(let headers):
                print("WebSocket is connected: \(headers)")
                Logger.shared.log("WebSocket is connected: \(headers)", level: .info)
                DispatchQueue.main.async {
                    self.stateVars.connectedToRobot = true
                }
            case .disconnected(let reason, let code):
                print("WebSocket is disconnected: \(reason) with code: \(code)")
                Logger.shared.log("WebSocket is disconnected: \(reason) with code: \(code)", level: .warning)
                DispatchQueue.main.async {
                    self.stateVars.connectedToRobot = false
                }
            case .text(let string):
                print("Received text: \(string)")
                Logger.shared.log("Received text: \(string)", level: .info)
                handleReceivedText(string)
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
                    self.stateVars.connectedToRobot = false
                }
            case .error(let error):
                print("Error: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.stateVars.connectedToRobot = false
                }
            case .peerClosed:
                print("WebSocket peer closed")
                Logger.shared.log("WebSocket peer closed", level: .warning)
                DispatchQueue.main.async {
                    self.stateVars.connectedToRobot = false
                }
            @unknown default:
                print("Unknown event received")
                Logger.shared.log("Unknown event received", level: .error)
            }
        
        func handleReceivedText(_ text: String) {
            if !text.contains("heartbeat") {return}
            if let data = text.data(using: .utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let heartbeat = json?["heartbeat"] as? Bool {
                        if heartbeat {
                            print("Received heartbeat from server")
                            // Optionally, you can add logic here to handle the heartbeat
                            // For example, update a last received time to reset server watchdog
//                            webSocketManager.sendData(key: "heartbeat", value: "true")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
}
