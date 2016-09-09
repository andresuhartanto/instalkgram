//
//  ViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/8/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

   
    @IBAction func onSignupButtonPressed(sender: UIButton) {
        
        guard
            let username = usernameTxt.text,
            let password = passwordTxt.text,
            let email = emailTxt.text
            else {
                return
        }
        
        //calling Firebase to create the user
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            //completed executing createUserWithEmail
            if let user = user {
                
                User.getSingleton.storeUserSession(username)
                self.performSegueWithIdentifier("WelcomeSegue", sender: sender)
    
                let currentUserRef = DataService.rootRef.child("users").child(user.uid)
                let userDict = ["email":email, "username":username]
                currentUserRef.setValue(userDict)
                
            } else {
                //failed
                let alert = UIAlertController(title: "Failed to sign up", message: error?.localizedDescription, preferredStyle: .Alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        })

    }
    
    

}

