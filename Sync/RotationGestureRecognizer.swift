//
//  RotationGestureRecognizer.swift
//  Sync
//
//  Created by Danny Zhuang on 6/2/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

public class RotationGestureRecognizer: UIPanGestureRecognizer {
    // represents the touch angle of the line which joins the current touch point to the center of the view to which the gesture recognizer is attached
    var rotation: CGFloat = 0.0
    
    // contains the layer that was touched
    //var touchedLayer: CALayer = CALayer()
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        updateRotationWithTouches(touches)
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        updateRotationWithTouches(touches)
    }
    
    public override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    // takes a set of touches and extracts the first touch, translates the touh point into the coordinate system of the view, and updates the rotation property
    func updateRotationWithTouches(touches: Set<UITouch>) {
        if let touch = touches[touches.startIndex] as? UITouch {
            self.rotation = rotationForLocation(touch.locationInView(self.view))
        }

            // need to check for the user actually clicking on the icon
            
            /* let point = touch.locationInView(self.view)
            // if you hit a layer
            if let pointLayer = self.view!.layer.hitTest(point) as CALayer? {
                // if you are inside its content path
                if CGPathContainsPoint(pointLayer.shadowPath, nil, point, false) {
                    touchedLayer = pointLayer
                    self.rotation = rotationForLocation(point)
                }
            } */
    }
    
    // converts touch point to an angle
    func rotationForLocation(location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
        let test = atan2(offset.y, offset.x)
        return atan2(offset.y, offset.x)
    }
}