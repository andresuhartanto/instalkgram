//
//  RelationshipViewController.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

class RelationshipViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var suggestedListToFollow = [InstallkgramUser]()
    
    
   
    
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

    
        print("count \(self.suggestedListToFollow.count)")
        for u in suggestedListToFollow {
            print("\(u.userUID) ....\(u.username)")
        }
    
    }

    func suggestFollowing(){
        
        //1. list all InstalkgramUser
        DataService.userRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let iuser = InstallkgramUser.init(snapshot: snapshot){
                self.suggestedListToFollow.append(iuser)
                self.tableview.reloadData()
            }
            
        })

    }
    
//    @IBAction func onFollowButtonPressed(sender: UIButton) {
//        
//        //if user didnt tap, then the indexPath will be nil
//        guard let idx = tableview.indexPathForSelectedRow else {return }
//        
//        let followingUser = suggestedListToFollow[idx.row]
//        
//        /**
//         1. add a relation
//         2. in current user, add a following relation
//         3. in following user, add a follower relation
//         **/
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
//        
//        tableview.reloadData() // not working
//    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedListToFollow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RelationCell")as? RelationshipTableViewCell
        
        let iuser = suggestedListToFollow[indexPath.row]
        cell!.usernameLbl.text=iuser.username
        cell!.fullnameLbl.text=iuser.lastName+" "+iuser.firstName
        
//        if cell!.followStatus {
//            cell!.followBtn.text = "Followed"
//        } else {
//            cell!.followBtn.text = "+Following"
//        }
        
        return cell!
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        tableView.indexPathForSelectedRow
//        
//        if cell!.followBtn[indexPath.row].text = "Followed" {
//            cell!.followStatus = true
//        } else if cell!.followBtn[indexPath.row].text = "Following" {
//            cell!.followedStatus = true
//        }
    }
    
}
