//
//  Knob.swift
//  tipster
//
//  Created by Sarn Wattanasri on 12/29/15.
//  Copyright © 2015 Sarn. All rights reserved.
//

import UIKit

public class Knob: UIControl {
    
    private var backingValue: Float = 0.0
    
    var maximumValue: Float = 1.0
    var minimumValue: Float = 0.0
    var continuous = true
    private let knobRenderer = KnobRenderer()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        createSublayers()
        
        let gr = RotationGestureRecognizer(target: self, action: "handleRotation:")
        self.addGestureRecognizer(gr)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleRotation(sender: AnyObject) {
        let gr = sender as! RotationGestureRecognizer
        
        //1. mid-point angle
        let midPointAngle =
        (2.0 * CGFloat(M_PI) + self.startAngle - self.endAngle) / 2.0 + self.endAngle
        
        //2. Ensure the angle is within a suitable range
        var boundedAngle = gr.rotation
        if boundedAngle > midPointAngle {
            boundedAngle -= 2.0 * CGFloat(M_PI)
        } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(M_PI)) {
            boundedAngle += 2 * CGFloat(M_PI)
        }
        
        //3. bound the angle to within the suitable range
        boundedAngle = min(self.endAngle, max(self.startAngle, boundedAngle))
        
        //4. Convert the angle to a value
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let valueForAngle =
        Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        //5. set the control to this value
        self.value = valueForAngle
    }
    
    var value: Float {
        get { return backingValue }
        set { setValue(newValue, animated: false) }
    }
    
    func setValue(value: Float, animated: Bool) {
        if value != self.value {
            //save the value to the backing value
            //limit it to the requested bounds
            self.backingValue = min(self.maximumValue, max(self.minimumValue, value))
        }
        
        //update the knob with the correct angle
        let angleRange = endAngle - startAngle
        let valueRange = CGFloat(maximumValue - minimumValue)
        let angle = CGFloat(value - minimumValue) / valueRange * angleRange + startAngle
        knobRenderer.setPointerAngle(angle, animated: animated)
        
        //set the backingValue for the knobRenderer
        knobRenderer.backingValue = CGFloat(value)
        
        //let the registered target know to invoke the action method
        //ex: to update TipCalculatorVC tip&total labels when knob value changed
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
    }
    
    func createSublayers() {
        knobRenderer.update(bounds)
        knobRenderer.strokeColor = tintColor
        knobRenderer.startAngle = -CGFloat(M_PI * 10.0 / 8.0)
        knobRenderer.endAngle = CGFloat(M_PI * 2.0 / 8.0 )
        knobRenderer.pointerAngle = knobRenderer.startAngle
        knobRenderer.lineWidth = 2.0
        knobRenderer.pointerLength = 6.0
        
        layer.addSublayer(knobRenderer.trackLayer)
        layer.addSublayer(knobRenderer.pointerLayer)
        layer.addSublayer(knobRenderer.labelLayer)
    }
    
    //exposing appearance properties in the API
    
    //specifies the angle of the start of the knob control track.  Defaults to -11M_PI/8
    public var startAngle: CGFloat {
        get { return knobRenderer.startAngle }
        set { knobRenderer.startAngle = newValue }
    }
    
    //specifies the end angle of the knob control track.  Defaults to 3M_PI/8
    public var endAngle: CGFloat {
        get { return knobRenderer.endAngle }
        set { knobRenderer.endAngle = newValue }
    }
    
    //specifies the width in points of the knob control track. defaults to 2.0
    public var lineWidth: CGFloat {
        get { return knobRenderer.lineWidth }
        set { knobRenderer.lineWidth = newValue }
    }
    
    //specifies the length in points of the pointer on the knob. defaults to 6.0
    public var pointerLength: CGFloat {
        get { return knobRenderer.pointerLength }
        set { knobRenderer.pointerLength = newValue }
    }
    
    ///////
    
    public override func tintColorDidChange() {
        knobRenderer.strokeColor = tintColor
    }
    
}



//============================================================================

private class KnobRenderer {
    
    let trackLayer = CAShapeLayer()
    let pointerLayer = CAShapeLayer()
    let labelLayer = CAShapeLayer()
    let labelTextLayer = CATextLayer()
    
    var strokeColor: UIColor {
        get {
            return UIColor(CGColor: trackLayer.strokeColor!)
        }
        set(strokeColor) {
            trackLayer.strokeColor = strokeColor.CGColor
            pointerLayer.strokeColor = strokeColor.CGColor
        }
    }
    
    var lineWidth: CGFloat = 1.0 {
        didSet { update() }
    }
    
    var startAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var endAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var backingPointerAngle: CGFloat = 0.0
    
    var backingValue: CGFloat = 0.0 {
        didSet { updateLabel() }
    }
    
    func updateLabel() {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        //make a CATextLayer and add it to the labelLayer
        labelTextLayer.font = "Helvetica-Bold"
        labelTextLayer.fontSize = 30.0
        labelTextLayer.string = "\(backingValue)"
        labelTextLayer.foregroundColor = UIColor.brownColor().CGColor
        labelTextLayer.alignmentMode = kCAAlignmentCenter
        labelTextLayer.string = formatter.stringFromNumber(backingValue)
        labelTextLayer.frame = CGRect(x: trackLayer.bounds.width / 2 - 40, y: trackLayer.bounds.height / 2 - 25, width: 80  , height: 80)
        
        labelLayer.addSublayer(labelTextLayer)
    }
    
    var pointerLength: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var pointerAngle: CGFloat {
        get { return backingPointerAngle }
        set { setPointerAngle(newValue, animated: false) }
    }
    
    init() {
        trackLayer.fillColor = UIColor.clearColor().CGColor
        pointerLayer.fillColor = UIColor.clearColor().CGColor
        
        labelLayer.fillColor = UIColor.clearColor().CGColor
        
        
        
        
    }
    
    func setPointerAngle(pointerAngle: CGFloat, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        
        if animated {
            let midAngle = (max(pointerAngle, self.pointerAngle) -
                min(pointerAngle, self.pointerAngle)) / 2.0 + min(pointerAngle, self.pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 0.25
            
            animation.values = [self.pointerAngle, midAngle, pointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pointerLayer.addAnimation(animation, forKey: nil)
        }
        
        CATransaction.commit()
        
        self.backingPointerAngle = pointerAngle
    }
    
    //create an arc between the startAngle and endAngle; position it on center of trackLayer
    func updateTrackLayerPath() {
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
        let offset = max(pointerLength, trackLayer.lineWidth / 2.0)
        let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - offset
        trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius,
            startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
    }
    
    //create the path for the pointer at the position where angle is zero
    func updatePointerLayerPath() {
        let path = UIBezierPath()
        var xValue = pointerLayer.bounds.width - pointerLength - pointerLayer.lineWidth / 2.0
        var yValue = pointerLayer.bounds.height / 2.0
        path.moveToPoint(CGPoint(x: xValue, y: yValue))
        
        xValue = pointerLayer.bounds.width
        yValue = pointerLayer.bounds.height / 2.0
        path.addLineToPoint(CGPoint(x: xValue, y: yValue))
        
        pointerLayer.path = path.CGPath
    }
    
    //callback for property observers
    func update() {
        trackLayer.lineWidth = lineWidth
        pointerLayer.lineWidth = lineWidth
        
        updateTrackLayerPath()
        updatePointerLayerPath()
    }
    
    func update(bounds: CGRect) {
        let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0 )
        
        trackLayer.bounds = bounds
        trackLayer.position = position
        
        pointerLayer.bounds = bounds
        pointerLayer.position = position
        
        update()
    }
}


import UIKit.UIGestureRecognizerSubclass

private class RotationGestureRecognizer: UIPanGestureRecognizer {
    
    var rotation: CGFloat = 0.0
    
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        updateRotationWithTouches(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches , withEvent: event )
        
        updateRotationWithTouches(touches)
    }
    
    func updateRotationWithTouches(touches: Set<UITouch>) {
        let touch = touches[touches.startIndex]
        self.rotation = rotationForLocation(touch.locationInView(self.view))
    }
    
    func rotationForLocation(location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y:location.y - view!.bounds.midY)
        return atan2(offset.y, offset.x)
    }
}
