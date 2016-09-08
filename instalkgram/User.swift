//
//  User.swift
//  instalkgram
//
//  Created by khong fong tze on 08/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseAuth

public class User{
    
    static let sessionKey = "MyIosChatUID"
    static var singleton:User?
    
    static var currentUserUid:  String {
        if let user = FIRAuth.auth()!.currentUser{
            print("logged in \(user.uid)")
        }
        
        print("Store \(NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as! String)")
        return NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as! String
    }
    
    static var currentUserName:  String {
        if let user = FIRAuth.auth()!.currentUser{
            //let uid = NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as! FIRUser
            guard
                let username = user.displayName
                else {return ""}
            
            return username
        }
        return ""
    }
    
    static var getSingleton: User {
        if singleton == nil{
            singleton = User()
        }
        return singleton!
    }
    
    func storeUserSession() {
        if let user = FIRAuth.auth()!.currentUser{
            NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: User.sessionKey)
        }
    }
    
    func removeUserSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(User.sessionKey)
    }
    
}
