//
//  RinkRenderer.swift
//  Sync
//
//  Created by Danny Zhuang on 5/30/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit
import QuartzCore

public class RinkRenderer {
    var strokeColor: UIColor {
        get {
            return UIColor(CGColor: trackLayer.strokeColor!)
        }
        set(strokeColor) {
            trackLayer.strokeColor = strokeColor.CGColor
            logoLayer.strokeColor = UIColor.whiteColor().CGColor
            //logoLayer.strokeColor = strokeColor.CGColor
            //pointerLayer.strokeColor = strokeColor.CGColor
            //pointerLayer.strokeColor = UIColor.redColor().CGColor
        }
    }
    
    var fillColor: UIColor {
        get {
            return UIColor(CGColor: trackLayer.fillColor!)
        }
        set(fillColor) {
            // set fill colors, but leave logo layer clear
            trackLayer.fillColor = fillColor.CGColor
            //logoLayer.fillColor = UIColor.clearColor().CGColor
            
            //pointerLayer.fillColor = fillColor.CGColor
            //pointerLayer.fillColor = UIColor.yellowColor().CGColor
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
    
    var trackRadius: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var logoRadius: CGFloat = 0.0 {
        didSet { update() }
    }

    // outer track
    let trackLayer = CAShapeLayer()
    
    // inner track (logo)
    let logoLayer = CAShapeLayer()
    
    // logo text
    let logoTextLayer = CATextLayer()
    
    // rotating layer that contains user's icon
    let userTrackLayer = CAShapeLayer()
    
    // layer containing user's icon 
    let userIconLayer = CAShapeLayer()
    
    // value of user's icon
    let valueTextLayer = CATextLayer()
    
    // pointer (user profile image)
    //let pointerLayer = CAShapeLayer()
    
    var backingPointerAngle: CGFloat = 0.0
    
    var userIconAngle: CGFloat {
        get { return backingPointerAngle }
        set { setPointerAngle(newValue, animated: false) }
    }
    
    var logoText: String = ""
    
    let fontName: CFStringRef = "Noteworthy-Light"
    
    let fontSize: CGFloat = 16.0
    
    let iconSize: CGFloat = 30.0
    
    /*var pointerLength: CGFloat = 0.0 {
        didSet { update() }
    }*/
    
    init() {
        trackLayer.fillColor = UIColor.clearColor().CGColor
        logoLayer.fillColor = UIColor.whiteColor().CGColor
        
        //pointerLayer.fillColor = UIColor.clearColor().CGColor
    }
    
    func setPointerAngle(pointerAngle: CGFloat, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        userTrackLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        // rotate the user icon in the opposite direction to create illusion of perma-vertical orientation
        userIconLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, -0.1)
        
        if animated {
            let midAngle = (max(pointerAngle, self.userIconAngle) - min(pointerAngle, self.userIconAngle)) / 2.0 + min(pointerAngle, self.userIconAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 0.25
            
            animation.values = [self.userIconAngle, midAngle, pointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            userTrackLayer.addAnimation(animation, forKey: nil)
            
        }
        CATransaction.commit()
        
        self.backingPointerAngle = pointerAngle
    }
    
    // draws the track layer
    func updateTrackLayerPath() {
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
        let offset = (trackLayer.lineWidth / 2.0)
        let radius = trackRadius - offset
        trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
    }
    
    // draws the logo layer and the logo text
    func updateLogoLayerPath() {
        let arcCenter = CGPoint(x: logoLayer.bounds.width / 2.0, y: logoLayer.bounds.height / 2.0)
        let offset = logoLayer.lineWidth / 2.0
        let radius = logoRadius
        logoLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).CGPath
        
        logoTextLayer.string = logoText
        // CGFont... ignores font size property
        logoTextLayer.font = CTFontCreateWithName(fontName, fontSize, nil)
        logoTextLayer.fontSize = fontSize
        logoTextLayer.foregroundColor = UIColor.blackColor().CGColor
        logoTextLayer.alignmentMode = kCAAlignmentCenter
        
        valueTextLayer.font = CTFontCreateWithName(fontName, fontSize, nil)
        valueTextLayer.fontSize = fontSize
        valueTextLayer.foregroundColor = UIColor.blackColor().CGColor
        valueTextLayer.alignmentMode = kCAAlignmentCenter
    }
    
    // retrieves user's profile picture and draws her icon
    func updateUserIconLayerPath() {
        // retrieve image, default no profile icon
        let image = UIImage(named: "no-profile-avatar-f")
        
        userIconLayer.contents = image!.rounded?.CGImage
    }
    
    // this polymorphic update function redraws the path and pointer every time one of the parameters (line width, etc) is updated
    func update() {
        trackLayer.lineWidth = lineWidth
        logoLayer.lineWidth = lineWidth
        //logoTextLayer.zPosition = 1
        //pointerLayer.lineWidth = lineWidth
        
        updateTrackLayerPath()
        updateLogoLayerPath()
        updateUserIconLayerPath()
        //updatePointerLayerPath()
    }

    // draws a new icon representing a user in the starting location
    func addNewProfileIcon() {
        /*let path = UIBezierPath()
         //path.moveToPoint(CGPoint(x: pointerLayer.bounds.width - pointerLength - pointerLayer.lineWidth / 2.0, y: pointerLayer.bounds.height / 2.0))
         path.moveToPoint(CGPoint(x: pointerLayer.bounds.width - pointerLength, y: pointerLayer.bounds.height / 2.0))
         path.addLineToPoint(CGPoint(x: pointerLayer.bounds.width, y: pointerLayer.bounds.height / 2.0))
         pointerLayer.path = path.CGPath*/
        
        //let position = CGPoint(x: viewBounds.width / 2.0, y: viewBounds.height / 2.0)
        let bounds: CGRect = CGRect(x: trackRadius + logoRadius, y: trackRadius - logoRadius / 2.0, width: logoRadius, height: logoRadius)
        
        let image = UIImage(named: "no-profile-avatar-f")
        
        // let layer = CALayer()
        let layer = CAShapeLayer()
        
        layer.contents = image!.rounded?.CGImage
        //layer.backgroundColor = UIColor.redColor().CGColor
        layer.frame = bounds
        //layer.position = position
        
        trackLayer.addSublayer(layer)
    }
    
    // resizes and repositions layers to be in the center of a bounding rectangle
    func update(bounds: CGRect) {
        let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        
        trackLayer.frame = bounds
        trackLayer.position = position
        
        logoLayer.frame = bounds
        logoLayer.position = position
        
        let height = logoTextLayer.bounds.size.height
        let fontSize = logoTextLayer.fontSize
        // shift y position of text layer to attempt to center vertically
        let yDiff = (height-fontSize)/3 - fontSize/15
        
        logoTextLayer.frame = bounds
        logoTextLayer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height + yDiff)
        
        /*pointerLayer.frame = CGRect(x: position.x, y: position.y, width: iconSize, height: iconSize)
        pointerLayer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0  - iconSize)*/
        
        // retrieve user's current position on the rink and display user's profile icon
        userTrackLayer.frame = CGRect(x: trackRadius - 2.0 * logoRadius, y: trackRadius - 2.0 * logoRadius, width: 4.0 * logoRadius, height: 4.0 * logoRadius)
        //userTrackLayer.position = CGPoint(x: 3.0 * logoRadius, y: trackRadius)
        //userTrackLayer.backgroundColor = UIColor.redColor().CGColor
        
        userIconLayer.frame = CGRect(x: 1.5 * logoRadius, y: 3.0 * logoRadius, width: logoRadius, height: logoRadius)
        
        valueTextLayer.frame = CGRect(x: logoRadius / 2.0, y: logoRadius / 2.0, width: logoRadius, height: logoRadius)
        
        update()
    }
}

