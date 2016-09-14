//
//  RelationshipViewController.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

class RelationshipViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, RelationshipTableViewCellDelegate {

    @IBOutlet weak var tableview: UITableView!
    var suggestedListToFollow = [InstallkgramUser]()
    //var suggest2 = Dictionary
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.dataSource=self
        self.tableview.delegate=self
        
        
        /* *
        1. show all users  -- to do: to exclude myself and already followed members
        2. click on followng -> add to RElationship.following, (current userid)USERS.following, (leader)USERS.followed
        3. click on unfollow -> remove RElationship.following, (current userid)USERS.following, (leader)USERS.followed
        */
    
        //suggestFollowing()
        //1. list all InstalkgramUser
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let iuser = InstallkgramUser.init(snapshot: snapshot){
                self.suggestedListToFollow.append(iuser)
                self.tableview.reloadData()
            }
            
        })
        
//        DataService.userRef.child(User.currentUserUid).child("following").observeEventType(.ChildAdded, withBlock: { (snapself) in
//            if let iuser = InstallkgramUser.init(snapshot: snapself){
//                self.suggestedListToFollow.append(iuser)
//                self.tableview.reloadData()
//            }
//
//        })

    }

//    func suggestFollowing(){
//        
//        var array1 = [String]
//        var array2 = [String]
//        
//        
//        //1. list all InstalkgramUser
//        DataService.userRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
//            if let iuser = InstallkgramUser.init(snapshot: snapshot){
//                array1.append(iuser)
//            }
//            
//        })
//        
//        //2. list all InstalkgramUser
//        DataService.userRef.child(User.currentUserUid).observeEventType(.Value, withBlock: { (snapshot) in
//            if let iuser = InstallkgramUser.init(snapshot: snapshot){
//                array2.append(iuser)
//            }
//            
//        })
//
//    }
    

    func handleFollower (sender: RelationshipTableViewCell, followStatus: Bool){
    
        let followingUser = suggestedListToFollow[sender.followBtn.tag]
        
        
        /**
         1. add a relation
         2. in current user, add a following relation
         3. in following user, add a follower relation
         **/
        
        //let aRelationDict = ["followingUserUID":followingUser.userUID ,"created_at":NSDate().timeIntervalSince1970,"followerUserUID":User.currentUserUid]
        
        //let relationRef = DataService.relationRef.childByAutoId()
        //relationRef.setValue(aRelationDict)
        
        DataService.userRef.child(User.currentUserUid).child("following").updateChildValues([followingUser.userUID:true])
        //DataService.userRef.child(User.currentUserUid).child("following").setValue([tweetRef.key:true])
        
        DataService.userRef.child(followingUser.userUID).child("follower").updateChildValues([User.currentUserUid:true])
        
        DataService.userRef.child(followingUser.userUID).child("images").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
        DataService.userRef.child(User.currentUserUid).child("feeds").updateChildValues([snapshot.key:true])
            
            
            
        })
        
        
        suggestedListToFollow.removeAtIndex(sender.followBtn.tag)
       
//        if followStatus {
//            sender.followBtn.titleLabel!.text="Followed"
//        } else {
//            sender.followBtn.titleLabel!.text="+Following"
//        }
        
        self.tableview.reloadData()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedListToFollow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RelationCell")as? RelationshipTableViewCell
        
        let iuser = suggestedListToFollow[indexPath.row]
        cell?.usernameLbl.text=iuser.username
        cell?.fullnameLbl.text=iuser.lastName+" "+iuser.firstName
        cell?.followBtn.tag = indexPath.row
        
//        if let stat = cell?.followStatus {
//            if stat {
//                cell?.followBtn.titleLabel!.text="Followed"
//            }
//            else {
//                cell?.followBtn.titleLabel!.text="+Following"
//            }
//        }

        cell?.delegate = self
        
        return cell!
    }
    
    
}
