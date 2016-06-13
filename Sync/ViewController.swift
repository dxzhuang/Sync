//
//  ViewController.swift
//  Sync
//
//  Created by Danny Zhuang on 5/19/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
// 

// Ideas
// We could potentially increase the logo layer's size for smaller blocks, and decrease it for larger blocks

// git commands
// git commit -am "message"
// git push origin master
// git pull

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var rink: Rink!
    @IBOutlet weak var rinkPlaceholder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        rink = Rink(frame: rinkPlaceholder.bounds)
        
        //rinkPlaceholder.backgroundColor = UIColor.yellowColor()
        
        rinkPlaceholder.addSubview(rink)
        
        // set user's initial starting value to last saved value
        //rink.value = valueSlider.value

        rink.updateValueLabel()
        
        rink.addTarget(self, action: "rinkValueChanged:", forControlEvents: .ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        /*let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if !isUserLoggedIn {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
        */
    }
    
    func rinkValueChanged(rink: Rink) {
        rink.updateValueLabel()
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        // un-authenticate the user
        try! FIRAuth.auth()!.signOut()
        
        // remove userID from keychain
        let removeSuccessful: Bool = KeychainWrapper.removeObjectForKey("userID")
        
        // go back to the login page
        self.performSegueWithIdentifier("loginView", sender: self)
    }
}

