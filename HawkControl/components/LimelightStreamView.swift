//
//  LimelightStreamView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 7/31/24.
//

import SwiftUI
import WebKit

struct LimelightStreamView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false // disable scrolling
        webView.allowsBackForwardNavigationGestures = false // disable navigation gestures
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        // fill whole screen
        webView.contentMode = .scaleAspectFit
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
