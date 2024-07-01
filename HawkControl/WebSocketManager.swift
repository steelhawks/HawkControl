//
//  WebSocketManager.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/29/24.
//

import Starscream


class WebSocketManager: ObservableObject {
    var delegate: WebSocketDelegateImpl = WebSocketDelegateImpl()
    static let shared = WebSocketManager()
    var socket: WebSocket?

    private init() {}

    func connect(ip: String, port: String) {
        var request = URLRequest(url: URL(string: "ws://\(ip):\(port)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = delegate
        socket?.connect()
    }

    func disconnect() {
        socket?.disconnect()
    }

    func sendData(key: String, value: String) {
        let message = "{\"\(key)\": \"\(value)\"}"
        socket?.write(string: message)
    }
}
