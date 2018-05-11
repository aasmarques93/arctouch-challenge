//
//  CircularProgressView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 4/28/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

@IBDesignable class CircularProgressView: UIView {
    struct DefaultColor {
        static let circleStrokeColor = HexColor.secondary.color.withAlphaComponent(0.1)
        static let circleFillColor = HexColor.primary.color
        static let progressCircleStrokeColor = HexColor.secondary.color
        static let progressCircleFillColor = UIColor.clear
    }
    
    // progress: Should be between 0 to 1
    @IBInspectable var progress: CGFloat = 0 { didSet { setNeedsDisplay() } }
    
    private var circleStrokeWidth: CGFloat = 5
    private var circleStrokeColor = DefaultColor.circleStrokeColor
    private var circleFillColor = DefaultColor.circleFillColor
    private var progressCircleStrokeColor = DefaultColor.progressCircleStrokeColor
    private var progressCircleFillColor = DefaultColor.progressCircleFillColor
    
    private let textLabel = UILabel()
    
    // MARK: Public Methods
    
    func setCircleStrokeWidth(_ circleStrokeWidth: CGFloat) {
        self.circleStrokeWidth = circleStrokeWidth
        setCircleStrokeColor()
    }
    
    func setCircleStrokeColor(_ circleStrokeColor: UIColor = DefaultColor.circleStrokeColor,
                              circleFillColor: UIColor = DefaultColor.circleFillColor,
                              progressCircleStrokeColor: UIColor = DefaultColor.progressCircleStrokeColor,
                              progressCircleFillColor: UIColor = DefaultColor.progressCircleFillColor) {
        
        self.circleStrokeColor = circleStrokeColor
        self.circleFillColor = circleFillColor
        self.progressCircleStrokeColor = progressCircleStrokeColor
        self.progressCircleFillColor = progressCircleFillColor
        
        setNeedsDisplay()
    }

    // MARK: Core Graphics Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        drawRect(rect, margin: 0, color: circleStrokeColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: circleFillColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: progressCircleFillColor, percentage: progress)
        
        drawProgressCircle(rect)
        
        textLabel.frame = rect
        textLabel.textAlignment = .center
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.textColor = HexColor.text.color
        textLabel.text = "\(Int(progress * 100))%"
        textLabel.removeFromSuperview()
        
        self.addSubview(textLabel)
    }
    
    private func drawRect(_ rect: CGRect, margin: CGFloat, color: UIColor, percentage: CGFloat) {
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - margin
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        context.move(to: center)
        
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = -.pi/2 + .pi * 2 * percentage
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.closePath()
        context.fillPath()
    }
    
    private func drawProgressCircle(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(circleStrokeWidth)
        context.setStrokeColor(progressCircleStrokeColor.cgColor)
        
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - (circleStrokeWidth / 2)
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = -.pi/2 + .pi * 2 * progress
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
}
