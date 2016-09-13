//
//  RelationshipTableViewCell.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit


class RelationshipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var followStatus = false
    
    /**copy**/
    weak var _tableView: UITableView!
    
    func rowIndex() -> Int {
        if _tableView == nil {
            _tableView = tableView()
        }
        
        return _tableView.indexPathForSelectedRow!.row
    }
    
    func tableView() -> UITableView! {
        if _tableView != nil {
            return _tableView
        }
        
        var view = self.superview
        while view != nil && !(view?.isKindOfClass(UITableView))! {
            view = view?.superview
        }
        
        self._tableView = view as! UITableView
        return _tableView
    }
    /**end copy**/
    
    @IBAction func onFollowingBtnPressed(sender: UIButton) {
    
        var idx = tableView().indexPathForSelectedRow
        
        print (idx!.row)
        
        //let followingUser = suggestedListToFollow[idx]
        
        /**
         1. add a relation
         2. in current user, add a following relation
         3. in following user, add a follower relation
         **/
//        
//        let aRelationDict = ["followingUserUID":followingUser.userUID ,"created_at":NSDate().timeIntervalSince1970,"followerUserUID":User.currentUserUid]
//        let followingRelationRef = DataService.followingRelationRef.childByAutoId()
//        followingRelationRef.setValue(aRelationDict)
//        
//        DataService.userRef.child(User.currentUserUid).child("following").updateChildValues([followingRelationRef.key:true])
//        
//        DataService.userRef.child(followingUser.userUID).child("follower").updateChildValues([followingRelationRef.key:true])
//        
//        
//        //suggestedListToFollow.removeAtIndex(idx.row)
        
        _tableView.reloadData() // not working
        
    }
    
}
