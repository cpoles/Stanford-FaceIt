//
//  FaceView.swift
//  FaceIt
//
//  Created by Carlos Poles on 20/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

@IBDesignable // allows the Interface Builder to render the view, directly in the canvas.
class FaceView: UIView {
    
    // Public API
    
    @IBInspectable // it lets us change the runtime attributes during runtime
    var scale: CGFloat = 0.9
    
    @IBInspectable
    var eyesOpen: Bool = true
    
    @IBInspectable
    var mouthCurvature: Double = 0.5 // 1.0 is full smile and -1.0 is full frown
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    
    @IBInspectable
    var color: UIColor = UIColor.blue
    
    // Private Implementation
    
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3.0
        static let skullRadiusToEyeRadius: CGFloat = 10.0
        static let skullRadiusToMouthWidth: CGFloat = 1.0
        static let skullRadiusToMouthHeight: CGFloat = 3.0
        static let skullRadiusToMouthOffset: CGFloat = 3.0
    }
    
    private var skullRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private var skullCentre: CGPoint {
        // the property center of the view is related to its superview and therefore in a different coordinate system
        // the same effect can be achieved by using the convert function:
        //  let skullCenter = convert(center, from: superview)
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func pathForEye(_ eye: Eye) -> UIBezierPath {
        
        func centerOfEye(_ eye: Eye) -> CGPoint {
            let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
            var eyeCenter = skullCentre
            eyeCenter.y -= eyeOffset
            eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
            return eyeCenter
        }
        
        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
        let eyeCenter = centerOfEye(eye)
        
        let path: UIBezierPath
        
        if eyesOpen {
            path = UIBezierPath(arcCenter: eyeCenter,
                                radius: eyeRadius,
                                startAngle: 0,
                                endAngle: CGFloat.pi * 2,
                                clockwise: true)
        } else {
            path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
        }
        
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        // draw a rectangle to serve as a reference for the smile
        // two points in the rectangle will serve as the control points for the bezier curve
        let mouthRect = CGRect(x: skullCentre.x - mouthWidth / 2,
                               y: skullCentre.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1,  min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3, y: start.y + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    

    private func pathForSkull() -> UIBezierPath {
        // Draw a circle
        let path = UIBezierPath(arcCenter: skullCentre,
                                radius: skullRadius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: false)
        path.lineWidth = 5.0
        
        return path
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        color.set()
        pathForSkull().stroke()
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
 
}
