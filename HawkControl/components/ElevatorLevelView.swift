//
//  ElevatorLevelView.swift
//  HawkControl
//
//  Created by Farhan Jamil on 8/15/24.
//

import UIKit

class ElevatorLevelView: UIView {
    var level: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay() // Redraw the view when the level changes
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Draw the elevator shaft
        context?.setFillColor(UIColor.gray.cgColor)
        context?.fill(CGRect(x: rect.width / 2 - 10, y: 0, width: 20, height: rect.height))
        
        // Draw the elevator at the correct level
        let elevatorHeight: CGFloat = 30
        let elevatorY = rect.height * (1 - level) - elevatorHeight / 2
        context?.setFillColor(UIColor.blue.cgColor)
        context?.fill(CGRect(x: rect.width / 2 - 15, y: elevatorY, width: 30, height: elevatorHeight))
    }
}
