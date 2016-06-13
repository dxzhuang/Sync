//
//  User.swift
//  Sync
//
//  Created by Danny Zhuang on 5/22/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit

class User : NSObject{
    var email: String
    var password: String
    var username: String
    var backingPointerAngle: CGFloat = 0.0
    
    var pointerAngle: CGFloat {
        get { return backingPointerAngle }
        set { backingPointerAngle = newValue }
    }
    
    init (email: String, username: String, password: String) {
        self.email = email;
        self.password = password;
        self.username = username;
    }
    
}