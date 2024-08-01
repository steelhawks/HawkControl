//
//  AVPlayerViewControllerRepresentable.swift
//  HawkControl
//
//  Created by Farhan Jamil on 7/31/24.
//

import SwiftUI
import AVKit

struct AVPlayerLayerRepresentable: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        // Observe player item status to start playing when ready
        if let currentItem = player.currentItem {
            currentItem.addObserver(context.coordinator, forKeyPath: "status", options: [.new, .initial], context: nil)
        } else {
            print("Player current item is nil")
        }

        // Print debug info
        print("AVPlayerLayer created and added to view")

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first as? AVPlayerLayer {
            playerLayer.frame = uiView.bounds
            playerLayer.player = player
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: AVPlayerLayerRepresentable

        init(_ parent: AVPlayerLayerRepresentable) {
            self.parent = parent
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "status", let playerItem = object as? AVPlayerItem {
                switch playerItem.status {
                case .readyToPlay:
                    print("Player item is ready to play")
                    Logger.shared.log("Player item is ready to play", level: .warning)
                    parent.player.play()
                case .failed:
                    print("Failed to load video: \(String(describing: playerItem.error))")
                    Logger.shared.log("Failed to load video", level: .error)
                case .unknown:
                    print("Player item status is unknown")
                    Logger.shared.log("Player item status is unknown", level: .warning)
                @unknown default:
                    print("Player item status is an unknown default")
                    Logger.shared.log("Player item status is an unknown default", level: .warning)
                }
            }
        }

        deinit {
            parent.player.currentItem?.removeObserver(self, forKeyPath: "status")
        }
    }
}
