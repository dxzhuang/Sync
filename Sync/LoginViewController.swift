//
//  LoginViewController.swift
//  Sync
//
//  Created by Danny Zhuang on 5/20/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user has been previously logged in
        if KeychainWrapper.stringForKey("userID") != nil {
            // check if user is currently authenticated
            FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
                if let user = user {
                    // user is signed in
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("viewController") as! ViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else {
                    // no user is signed in
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        let username = usernameTextField.text!
        let userPassword = userPasswordTextField.text!

        if username.isEmpty || userPassword.isEmpty {
            displayMyAlertMessage(self, userMessage: "both username and password required.", useHandler: false)
            return
        }
        // Retrieve username and password stored in Firebase
        let userRef = REF.child("users").child(username)
        
        let _ = userRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: {
            snapshot -> Void in
            // check existence of username
            if snapshot.exists() {
                // username exists, get email address of user
                let userEmail = snapshot.value!["userEmail"] as! String
                
                // authenticate user
                FIRAuth.auth()?.signInWithEmail(userEmail, password: userPassword) { (user, error) in
                    if error == nil {
                        // user successfully signed in
                        let savedUserID = KeychainWrapper.setString(user!.uid, forKey: "userID")
                        // sign user in; show protected view controller
                        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("viewController") as! ViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                    else {
                        // not signed in
                        displayMyAlertMessage(self, userMessage: error!.localizedDescription, useHandler: false)
                    }
                }
            }
            else {
                displayMyAlertMessage(self, userMessage: "invalid username. please try again", useHandler: false)
            }
            
        })

        /*let usernameStored = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        let userPasswordStored = NSUserDefaults.standardUserDefaults().stringForKey("userPassword")
        
        

        if (usernameStored == username || userPasswordStored == userPassword)
        {
            // Login successful
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
            //NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        else
        {
            
        }*/
    }

}
