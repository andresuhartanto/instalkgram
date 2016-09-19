//
//  UserComment.swift
//  instalkgram
//
//  Created by khong fong tze on 15/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserComment {
    
    var user : InstallkgramUser
    var createdAt : Double
    var text : String
    var commentUID : String
    var imageUID : String
    
    init() {
        user = InstallkgramUser()
        createdAt = 0
        text = ""
        commentUID = ""
        imageUID = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        user = InstallkgramUser()
        commentUID = snapshot.key
        

        if let dictText = dict["text"] as? String {
            self.text = dictText
        } else {
            self.text = ""
        }
        
        if let dictCreatedAt = dict["created_at"] as? Double {
            self.createdAt = dictCreatedAt
        } else {
            self.createdAt = 0.0
        }
        
        if let dictImgUID = dict["imageUID"] as? String {
            self.imageUID = dictImgUID
        }
        else {
            self.imageUID = ""
        }
        
        if let dictUserUID = dict["userUID"] as? String {
            self.user.userUID = dictUserUID
        }
        else {
            self.user.userUID = ""
        }
        
       retrieveUser()
        
    }
    
    func retrieveUser() {
    
        DataService.userRef.child(self.user.userUID).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let aUser = InstallkgramUser.init(snapshot: snapshot){
                self.user = aUser
            }
        })
        
    }
    
    func displayDateTime() -> String {
        
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        let tweetDate = NSDate(timeIntervalSince1970: createdAt)
        let x = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let duration = currentDate.timeIntervalSince1970 - tweetDate.timeIntervalSince1970
        //print("diff \(duration/60)..\(currentDate.timeIntervalSince1970)")
        
//        let today = x!.isDateInToday(tweetDate)
//        
//        if today {
//            dateFormatter.dateFormat = "HH:MM"
//        } else {
//            dateFormatter.dateFormat = "MMM dd, yyyy HH:MM"
//        }
        
//        return dateFormatter.stringFromDate(tweetDate)
        
        //var d : Int
        let d = Int(round(duration/60))
        
        
        if d < 2 {
            return "\(d) minute ago"
        } else {
            if (d>=2) && (d<60) {
                return "\(d) minutes ago"
            } else {
                if (d>=60) && (d<120) {
                    return "\(d) hour ago"
                } else {
                    return "\(d) hours ago"
                }
            }
        }
    }
 
}