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
    //var photo: String
    var followingUsers  = [String]()
    var followers  = [String]()

    
    init(){
        username = ""
        userUID = ""
        createdAt = 0.0
        firstName = ""
        lastName = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        userUID = snapshot.key
        
        print("\(userUID) ...\(snapshot.key)...\(dict["username"])")
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
        
        if let userID = dict["userUID"] as? String{
            self.userUID = userID
        }else {
            self.userUID = ""
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
        
        //decodeRelation(dict["relations"])
        
    }
    
    
//    func decodeRelation(relationDict:AnyObject?) {
//        guard let
//    }
    


}