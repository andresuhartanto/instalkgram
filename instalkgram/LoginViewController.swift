//
//  LoginViewController.swift
//  instalkgram
//
//  Created by khong fong tze on 08/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func onNoAcctPressed(sender: UIButton) {
        
    }
    

    
    
    @IBAction func onLoginBtnPressed(sender: UIButton) {
        guard
            let email = emailTxt.text,
            let password = passwordTxt.text else {
                return }
        
        
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let user = user{
                //store into user defaults
                
                
                var username=""

                    DataService.userRef.child(user.uid).observeEventType(.Value, withBlock: { (snapshot) in
                        if let myself = InstallkgramUser.init(snapshot: snapshot){
                            username = myself.username
                            User.getSingleton.storeUserSession(username)
                        }
                        
                    })

                
                print("username \(username)")
                //User.getSingleton.storeUserSession(username)

                
                self.performSegueWithIdentifier("LogInSegue", sender: nil)
            } else {
                //failed
                let alert = UIAlertController(title: "Sign In Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        })

    }
    

}
