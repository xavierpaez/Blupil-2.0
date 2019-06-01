//
//  PillView.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/26/18.
//  Copyright © 2018 XavierPaez. All rights reserved.
//

import UIKit

class PillView: UIView {

    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        simpleShapeLayer()
//        maskVsSublayer()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createReactangle() {
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        // Create the bottom line (bottom-left to bottom-right).
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        // Create the vertical line from the bottom-right to the top-right side.
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        
        // Close the path. This will create the last line automatically.
        path.close()
    }
    
 
    func createPillshape() {
        path = UIBezierPath()
        let pillRadius = self.frame.width/2 - 70
        path.addArc(withCenter: CGPoint(x: self.frame.width/2, y: pillRadius), radius: self.frame.width/2-70, startAngle: CGFloat(180.0).toRadians(), endAngle:CGFloat(0.0).toRadians(), clockwise: true)
        path.addLine(to: CGPoint(x: self.frame.width/2 + pillRadius, y: self.frame.height-pillRadius))
        path.addArc(withCenter: (CGPoint(x: self.frame.width/2, y: self.frame.height-pillRadius)), radius: pillRadius, startAngle: CGFloat(0.0).toRadians(), endAngle: CGFloat(180.0).toRadians(), clockwise: true)
        path.close()
    }
    
    
    
    func simpleShapeLayer() {

        self.createPillshape()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = self.path.cgPath
        shapeLayer.fillColor = UIColor(colorWithHexValue: 0x2BA4FF).cgColor
        shapeLayer.strokeColor = UIColor(red:0.24, green:0.50, blue:0.75, alpha:1.0).cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineWidth = 12.0
        self.layer.addSublayer(shapeLayer)
        
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.toValue = 1
//        animation.duration = 2 // seconds
//        animation.autoreverses = true
//        animation.repeatCount = .infinity
//        animation.fillMode = CAMediaTimingFillMode.forwards
////
//        shapeLayer.add(animation, forKey: "line")
    }
    
  

    
    func maskVsSublayer() {
       
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.fillColor = UIColor.yellow.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
