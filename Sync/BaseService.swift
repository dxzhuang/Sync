//
//  BaseService.swift
//  Sync
//
//  Created by Danny Zhuang on 5/24/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

/*
 for making 2x and 1x images, use app prepo
 otherwise use photoshop/sketch to make art assets
 */

import Foundation
import Firebase

let REF: FIRDatabaseReference = FIRDatabase.database().reference()

var CURRENT_USER: FIRDatabaseReference
{
    let userID = KeychainWrapper.stringForKey("userID")

    let currentUser = REF.child("users").child(userID!)
    
    return currentUser
 
}

// Display alert message with confirmation
func displayMyAlertMessage(controller: UIViewController, userMessage:String, useHandler:Bool)
{
    let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) { action in
        if useHandler {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    myAlert.addAction(okAction)
    controller.presentViewController(myAlert, animated: true, completion: nil)
}