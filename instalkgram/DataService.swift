//
//  DataService.swift
//  instalkgram
//
//  Created by khong fong tze on 08/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct DataService {
    static var rootRef = FIRDatabase.database().reference()
    static var userRef = FIRDatabase.database().reference().child("users")
    static var followingRelationRef = FIRDatabase.database().reference().child("relation").child("following")
    static var followerRelationRef = FIRDatabase.database().reference().child("relation").child("follower")
    

}