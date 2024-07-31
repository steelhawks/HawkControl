//
//  WebSocketManager.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/29/24.
//

import Starscream
import Foundation


class WebSocketManager: ObservableObject {
    var delegate: WebSocketDelegateImpl = WebSocketDelegateImpl()
    static let shared = WebSocketManager()
    var socket: WebSocket?
    var heartbeatTimer: Timer?

    private init() {}

    func connect(ip: String, port: String) {
        var request = URLRequest(url: URL(string: "ws://\(ip):\(port)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = delegate
        socket?.connect()
        startHeartbeat()
    }

    func disconnect() {
        socket?.disconnect()
        stopHeartbeat()
    }

    func sendData(key: String, value: String) {
        let message = "{\"\(key)\": \"\(value)\"}"
        socket?.write(string: message)
    }
    
    private func startHeartbeat() {
        stopHeartbeat()
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.sendData(key: "heartbeat", value: "true")
        }
    }

    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
}
