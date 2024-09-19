//
//  ViewController.swift
//  HawkControl
//
//  Created by Farhan Jamil on 9/4/24.
//

import UIKit
import PencilKit


class ViewController: UIViewController {
    private let canvasView: PKCanvasView = {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        return canvas
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvasView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        canvasView.frame = view.bounds
    }
}
