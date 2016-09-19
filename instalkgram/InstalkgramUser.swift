//
//  InstalkgramUser.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class InstallkgramUser{
    
    var userUID: String
    var username: String
    var lastName: String
    var firstName: String
    var createdAt: Double
    var email: String
    var photoURL: String?
    var followingDict=[String]()
    var followerDict=[String]()
    var images = [Image]()
    
    init(){
        username = ""
        userUID = ""
        createdAt = 0.0
        firstName = ""
        lastName = ""
        email = ""
        photoURL = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        userUID = snapshot.key
        
        //print("dictionary \(dict)")
        if let dictUsername = dict["username"] as? String {
            self.username = dictUsername
        } else {
            self.username = ""
        }
        
        if let createdAt = dict["created_at"] as? Double {
            self.createdAt = createdAt
        } else {
            self.createdAt = 0.0
        }
        
        if let email = dict["email"] as? String{
            self.email = email
        }else {
            self.email = ""
        }
        
        if let firstName = dict["firstName"] as? String{
            self.firstName = firstName
        }else {
            self.firstName = ""
        }
        
        if let lastName = dict["lastName"] as? String{
            self.lastName = lastName
        }else {
            self.lastName = ""
        }
        
//        if let photoURL = dict["profile_photo_url"] as? String{
//            self.photoURL = photoURL
//        }else {
//            self.photoURL = ""
//        }
        
        
        //self.retrieveRelation()
        //print("step1.1 \(self.userUID)...\(self.username)")
    
    }
    
}