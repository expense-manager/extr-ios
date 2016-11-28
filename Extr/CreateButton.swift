//
//  CreateView.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/26/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CreateButton: UIView {
    
    var buttonColor: CGColor = UIColor.orange.cgColor
    var crossWidth: CGFloat = 1
    var crossPadding: CGFloat = 10
    var maskLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        let radius = self.frame.width / 2
        let halfCrossWidth = self.crossWidth / 2
        
        let crossPath = UIBezierPath()
        crossPath.move(to: CGPoint(x: radius - halfCrossWidth, y: crossPadding))
        crossPath.addLine(to: CGPoint(x: radius - halfCrossWidth, y: radius - halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: crossPadding, y: radius - halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: crossPadding, y: radius + halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius - halfCrossWidth, y: radius + halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius - halfCrossWidth, y: radius * 2 - crossPadding))
        crossPath.addLine(to: CGPoint(x: radius + halfCrossWidth, y: radius * 2 - crossPadding ))
        crossPath.addLine(to: CGPoint(x: radius + halfCrossWidth, y: radius + halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius * 2 - crossPadding, y: radius + halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius * 2 - crossPadding, y: radius - halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius + halfCrossWidth, y: radius - halfCrossWidth))
        crossPath.addLine(to: CGPoint(x: radius + halfCrossWidth, y: crossPadding))
        crossPath.close()
        
        let backgroundPath = UIBezierPath(roundedRect: mainView.bounds, cornerRadius: self.frame.width / 2)
        backgroundPath.usesEvenOddFillRule = true
        backgroundPath.append(crossPath)
        
        maskLayer = CAShapeLayer()
        maskLayer?.path = backgroundPath.cgPath
        maskLayer?.fillColor = self.buttonColor
        maskLayer?.opacity = 1
        
        mainView.layer.addSublayer(maskLayer!)
        mainView.clipsToBounds = true
        mainView.alpha = 1
        
        self.addSubview(mainView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let _ = touch.location(in: self)

        }
        
        self.maskLayer?.fillColor = UIColor.gray.cgColor
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let _ = touch.location(in: self)
        }
        
        self.maskLayer?.fillColor = self.buttonColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let _ = touch.location(in: self)
        }
        
        self.maskLayer?.fillColor = self.buttonColor
    }
}
