//
//  Image.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Image {
    var downloadURL: String
    var userUID : String
    var createdAt: Double
    var imageID: String
    
    init(){
        downloadURL = ""
        userUID = ""
        createdAt = 0.0
        imageID = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
         imageID = snapshot.key
        
        if let dictURL = dict["downloadURL"] as? String {
            self.downloadURL = dictURL
        } else {
            self.downloadURL = ""
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
    }
    
    
}
