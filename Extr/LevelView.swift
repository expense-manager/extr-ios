//
//  LevelView.swift
//  Extr
//
//  Created by Zekun Wang on 12/7/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//
import UIKit

class LevelView: UIView {
    
    var frontColor: CGColor = AppConstants.cyan_deep.cgColor
    var crossWidth: CGFloat = 1
    var crossPadding: CGFloat = 0
    var maskLayer: CAShapeLayer?
    
    var fullColor: UIColor = AppConstants.cyan
    var emptyColor: UIColor = AppConstants.yellow
    let colorLayer = CAGradientLayer()
    
    var fullTimeInSecond: Double = 2
    var endPosition: Double = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = emptyColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func play() {
        let startLocations = [1, 0]
        let endLocations = [endPosition, 0]
        
        colorLayer.colors = [fullColor.cgColor, emptyColor.cgColor]
        print("minX: \(colorLayer.frame.minX), maxX: \(colorLayer.frame.maxX)")
        print("minY: \(colorLayer.frame.minY), maxY: \(colorLayer.frame.maxY)")
        colorLayer.locations = startLocations as [NSNumber]?
        colorLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        colorLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = fullTimeInSecond * (1 - endPosition)
        colorLayer.add(anim, forKey: "loc")
        colorLayer.locations = endLocations as [NSNumber]?
    }
    
    override func draw(_ rect: CGRect) {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        colorLayer.frame = mainView.frame
        mainView.layer.addSublayer(colorLayer)
        
        let halfWidth = self.frame.width / 2
        let halfHeight = self.frame.height / 2
        let radius = min(halfWidth, halfHeight) - crossPadding
        let backgroundPath = UIBezierPath(roundedRect: mainView.frame, cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: halfWidth - radius - 1, y: halfHeight - radius - 1, width: 2 * radius + 2, height: 2 * radius + 2), cornerRadius: radius)

        backgroundPath.usesEvenOddFillRule = true
        backgroundPath.append(circlePath)
        
        maskLayer = CAShapeLayer()
        maskLayer?.path = backgroundPath.cgPath
        maskLayer?.fillRule = kCAFillRuleEvenOdd
        maskLayer?.fillColor = self.frontColor
        maskLayer?.opacity = 1
        
        mainView.layer.addSublayer(maskLayer!)
        mainView.clipsToBounds = true
        mainView.alpha = 1
        
        self.addSubview(mainView)
        
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
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
        
        self.maskLayer?.fillColor = self.frontColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let _ = touch.location(in: self)
        }
        
        self.maskLayer?.fillColor = self.frontColor
    }
}
