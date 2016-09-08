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
    var userDisplayName: String?
    
    static var currentUserUid:  String {
        if let user = FIRAuth.auth()!.currentUser{
            print("logged in \(user.uid)")
        }
        
        print("Store \(NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as! String)")
        return NSUserDefaults.standardUserDefaults().objectForKey(User.sessionKey) as! String
    }
    
    static var currentUserName:  String {
            guard
                let username = self.getSingleton.userDisplayName
                else {return ""}
            
            return username
    }
    
    static var getSingleton: User {
        if singleton == nil{
            singleton = User()
        }
        return singleton!
    }
    
    func storeUserSession(username:String) {
        if let user = FIRAuth.auth()!.currentUser{
            NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: User.sessionKey)
            userDisplayName=username
        }
    }
    
    func removeUserSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(User.sessionKey)
    }
    
}
