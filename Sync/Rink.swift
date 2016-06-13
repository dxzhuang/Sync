//
//  Rink.swift
//  Sync
//
//  Created by Danny Zhuang on 5/30/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit

public class Rink: UIControl {
    private var backingValue: Float = 0.0
    
    private let rinkRenderer = RinkRenderer()
    
    /** Contains the receiver's current value. */
    public var value: Float {
        get { return backingValue }
        set { setValue(newValue, animated: false) }
    }
    
    /** Specifies the angle of the start of the rink's control track. Defaults to -π/2 */
    public var startAngle: CGFloat {
        get { return rinkRenderer.startAngle }
        set { rinkRenderer.startAngle = newValue }
    }
    
    /** Specifies the end angle of the kob control track. Defaults to 3π/2 */
    public var endAngle: CGFloat {
        get { return rinkRenderer.endAngle }
        set { rinkRenderer.endAngle = newValue }
    }
    
    /** Specifies the width in points of the rink control track. Defaults to 2.0 */
    public var lineWidth: CGFloat {
        get { return rinkRenderer.lineWidth }
        set { rinkRenderer.lineWidth = newValue }
    }
    
    /** Contains the currently touched profile icon of CALayer type */
    public var touchedLayer: CALayer {
        get { return touchedLayer }
        set { touchedLayer = newValue }
    }
    
    /** Called on all views beneath the current view in the view hierarchy */
    public override func tintColorDidChange() {
        rinkRenderer.strokeColor = tintColor
    }
    
    /** Specifies the length in points of the pointer on the knob. Defaults to 6.0 */
    /*public var pointerLength: CGFloat {
        get { return rinkRenderer.pointerLength }
        set { rinkRenderer.pointerLength = newValue }
    }*/
    
    /** Contains the minimum value of the receiver. */
    public var minimumValue: Float = 0.0
    
    /** Contains the maximum value of the receiver. */
    public var maximumValue: Float = 1.0
    
    /** Contains a Boolean value indicating whether changes
     in the sliders value generate continuous update events. */
    public var continuous: Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSublayers()
        
        // create gesture recognizer and add it to the view (rink)
        let gr = RotationGestureRecognizer(target: self, action: "handleRotation:")
        self.addGestureRecognizer(gr)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** Sets the receiver's current value, allowing you to animate the change visually. */
    public func setValue(value: Float, animated: Bool) {
        if value != self.value {
            // Save the value to the backing value
            // Make sure we limit it to the requested bounds
            self.backingValue = min(self.maximumValue, max(self.minimumValue, value))
            
            // print(value.description + " : " + self.backingValue.description)
            
            // Now let's update the knob with the correct angle
            let angleRange = endAngle - startAngle
            let valueRange = CGFloat(maximumValue - minimumValue)
            let angle = CGFloat(value - minimumValue) / valueRange * angleRange + startAngle
            
            rinkRenderer.setPointerAngle(angle, animated: animated)
        }
    }

    func rad(value: Double) -> Double {
        return value * M_PI / 180.0
    }
    
    // update the label with the value of the user
    func updateValueLabel() {
        rinkRenderer.valueTextLayer.string = NSNumberFormatter.localizedStringFromNumber(self.value, numberStyle: .DecimalStyle)
    }
    
    // sets rink size and adds layers as sublayers to control's layer
    func createSublayers() {
        rinkRenderer.logoText = "Σync"
        rinkRenderer.trackRadius = CGFloat(min(bounds.height, bounds.width) / 2.0)
        rinkRenderer.logoRadius = CGFloat(min(bounds.height, bounds.width) / 10.0)
        rinkRenderer.update(bounds)
        rinkRenderer.strokeColor = tintColor
        rinkRenderer.fillColor = tintColor
        rinkRenderer.startAngle = CGFloat(-rad(90))
        rinkRenderer.endAngle = CGFloat(rad(360-90))
        rinkRenderer.userIconAngle = rinkRenderer.startAngle
        rinkRenderer.lineWidth = 2
        //rinkRenderer.pointerLength = 6.0

        self.layer.addSublayer(rinkRenderer.trackLayer)
        self.layer.addSublayer(rinkRenderer.logoLayer)
        self.layer.addSublayer(rinkRenderer.logoTextLayer)
        rinkRenderer.userTrackLayer.addSublayer(rinkRenderer.userIconLayer)
        self.layer.addSublayer(rinkRenderer.userTrackLayer)
        self.layer.addSublayer(rinkRenderer.valueTextLayer)
        //rinkRenderer.addNewProfileIcon()
    }
    
    // extracts the angle from the custom gesture recognizer, converts it to the value represented by the angle on the knob control, and sets the value to trigger the UI updates
    func handleRotation(sender: AnyObject) {
        let gr = sender as! RotationGestureRecognizer
        
        // 1. Mid-point angle
        let midPointAngle = (2.0 * CGFloat(M_PI) + self.startAngle - self.endAngle) / 2.0 + self.endAngle
        
        // 2. Ensure the angle is within a suitable range
        var boundedAngle = gr.rotation
        if boundedAngle > midPointAngle {
            boundedAngle -= 2.0 * CGFloat(M_PI)
        } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(M_PI)) {
            boundedAngle += 2.0 * CGFloat(M_PI)
        }
        
        // 3. Bound the angle to within the suitable range
        boundedAngle = min(self.endAngle, max(self.startAngle, boundedAngle))
        
        // 4. Convert the angle to a value
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let valueForAngle = Float(boundedAngle) / Float(angleRange) * valueRange + minimumValue
        
        // get current profile icon being dragged
        //touchedLayer = gr.touchedLayer
        
        // 5. Set the control to this value
        self.value = valueForAngle
        
        // Notify of value change
        if continuous {
            sendActionsForControlEvents(.ValueChanged)
        } else {
            // Only send an update if the gesture has completed
            if (gr.state == UIGestureRecognizerState.Ended) || (gr.state == UIGestureRecognizerState.Cancelled) {
                sendActionsForControlEvents(.ValueChanged)
            }
        }
    }
    
    
}
