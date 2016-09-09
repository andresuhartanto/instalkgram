//
//  StorageService.swift
//  instalkgram
//
//  Created by khong fong tze on 09/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseStorage

struct StorageService {
    static let storageRefName="gs://instalkgram.appspot.com"
    static let storage = FIRStorage.storage()
    static let storageRef = storage.referenceForURL(storageRefName)
    
    
}