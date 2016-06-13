//
//  RegisterPageViewController.swift
//  Sync
//
//  Created by Danny Zhuang on 5/20/16.
//  Copyright © 2016 Danny Zhuang. All rights reserved.
//

import UIKit
import Firebase

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        let userRepeatedPassword = repeatPasswordTextField.text!
        let username = usernameTextField.text!
        
        // Check for empty fields
        if (userEmail.isEmpty || userPassword.isEmpty || userRepeatedPassword.isEmpty || username.isEmpty) {
            // Display alert message
            displayMyAlertMessage(self, userMessage: "All fields are required", useHandler: false)
            return
        }
        
        // Compare passwords
        if (userPassword != userRepeatedPassword) {
            // Display alert message
            displayMyAlertMessage(self, userMessage: "Passwords do not match", useHandler: false)
            return
        }

        // Check username is unique in Firebase database
        let newUserRef = REF.child("users").child(username)
        
        let _ = newUserRef.observeSingleEventOfType(FIRDataEventType.Value, withBlock: {snapshot -> Void in
            // check uniqueness of username to prevent user over-writing
            if !snapshot.exists() {
                // Write new user's basic information to Firebase's user database (for Authentication)
                FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword, completion: { (user, error) -> Void in
                    if error == nil {
                        // user successfully created, store data locally (encrypted)
                        let savedUserEmail = KeychainWrapper.setString(userEmail, forKey: "userEmail")
                        let savedUserPassword = KeychainWrapper.setString(userPassword, forKey: "userPassword")
                        let savedUsername = KeychainWrapper.setString(username, forKey: "username")
                        let savedUserID = KeychainWrapper.setString(user!.uid, forKey: "userID")
                        
                        newUserRef.setValue(["userEmail": userEmail, "userPassword": userPassword])
                        displayMyAlertMessage(self, userMessage: "Registration successful!", useHandler: true)
                    }
                    else {
                        displayMyAlertMessage(self, userMessage: error!.localizedDescription, useHandler: false)
                    }
                })
            }
            else {
                displayMyAlertMessage(self, userMessage: "The username " + username + " is unavailable, please choose another.", useHandler: false)
            }
                /*{
                displayMyAlertMessage(self, userMessage: "The username " + username + " is unavailable, please choose another.", useHandler: false)
                return
            }*/
        })
        
        /*
        // Read data and react to changes with event listener
        ref.observeEventType(FIRDataEventType.Value, withBlock: {
            (snapshot) -> Void in
            print(snapshot.key)
            print(snapshot.value)
        })
 
        // remove listeners at reference
        ref.removeAllObservers()
        */
    }
}
