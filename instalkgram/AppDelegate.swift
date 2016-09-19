//
//  AppDelegate.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/8/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        IQKeyboardManager.sharedManager().enable = true
        FIRDatabase.database().persistenceEnabled = true
        
        //if let _ = NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as? String{
        if User.getSingleton.isUserLoggedIn() {
            // load storyboard
            let storyboard = UIStoryboard(name: "AfterLogin", bundle: NSBundle.mainBundle())
            
            // load view controller with the storyboardID of ChatListViewController
            let ChatListViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarVC")
            
            self.window?.rootViewController = ChatListViewController
            
        }
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    /*GIDSignInDelegate */
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        
        let email = user.profile.email
        let username = user.profile.name
        
        FIRAuth.auth()?.signInWithCredential(credential) { (firebaseUser, error) in
            if let firebaseUser=firebaseUser {
                
                //NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "MyIosChatUID")
                User.getSingleton.storeUserSession(username)
                
                //print("key \(NSUserDefaults.standardUserDefaults().objectForKey("MyIosChatUID"))")
                let currentUserRef = DataService.userRef.child(firebaseUser.uid)
                let userDict = ["email": email, "username": username]
                
                currentUserRef.setValue(userDict)
                
                let storyBoard = UIStoryboard(name:"AfterLogin", bundle:NSBundle.mainBundle())
                //load viewcontroller with the storyboardID of HomeTabBarController
                //To Do: replace with the appropriate page
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("TabBarVC")
                self.window?.rootViewController=tabBarController
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        try! FIRAuth.auth()!.signOut()
        User.getSingleton.removeUserSession()
    }

    
    //google & fb for ios9
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print ("google ios9")
        
        if GIDSignIn.sharedInstance().handleURL(url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey]){
            return true
        }
//        else {
//            FBSDKApplicationDelegate.sharedInstance().application(app, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
//            return true
//        }
        return true
    }
    
    //google & fb for ios8 and older.
    //google & fb for ios8 and older.
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        //if let a = annotation as UIApplicationOpenURLOptionsAnnotationKey {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation!]
        return GIDSignIn.sharedInstance().handleURL(url,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
        //}
        
        //return nil
    }
//    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
//        //print("sourceApplication \(sourceApplication)")
//        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
//    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

