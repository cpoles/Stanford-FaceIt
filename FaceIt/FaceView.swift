//
//  FaceView.swift
//  FaceIt
//
//  Created by Carlos Poles on 20/11/17.
//  Copyright © 2017 Carlos Poles. All rights reserved.
//

import UIKit

class FaceView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let skullRadius = min(bounds.size.width, bounds.size.height) / 2
        
        
        // the property center of the view is related to its superview and therefore in a different coordinate system
        // the same effect can be achieved by using the convert function:
        //  let skullCenter = convert(center, from: superview)
        
        let skullCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        
        // Draw a circle
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        path.lineWidth = 5.0
        UIColor.blue.set()
        path.stroke()
        
        
        
        
        
    }
 

}
