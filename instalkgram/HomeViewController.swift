//
//  HomeViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, TableViewCellDelegate {

    @IBOutlet weak var feedTableView: UITableView!
    var imagesForFeed = [Image]()
    var usernameForFeed = [InstallkgramUser]()
    var imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.userRef.child(User.currentUserUid).observeSingleEventOfType(.Value, withBlock: {(snapself) in
            print("snapselfkey \(snapself.key)")
            if let username = InstallkgramUser.init(snapshot: snapself){
                self.usernameForFeed.append(username)
                self.retrieveFeed(username)
                
                //to cater - user come here without login (did not sign out in previous session)
                User.getSingleton.storeUserSession(username.username)
                }
            })
        self.retrieveFollowedUsersImages()
    }

    func retrieveFollowedUsersImages(){
        DataService.userRef.child(User.currentUserUid).child("following").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            print("snapshotkey \(snapshot.key)")
            
            DataService.userRef.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: {(snap1) in
                
                print("snap1key \(snap1.key)")
                
                if let username = InstallkgramUser.init(snapshot: snap1){
                    self.usernameForFeed.append(username)
                    self.retrieveFeed(username)
                }
                
            })
        })
    }
    
    
    func retrieveFeed(username:InstallkgramUser){
        /**andre**/
        DataService.userRef.child(username.userUID).child("images").observeEventType(.ChildAdded , withBlock: { (snap2) in
            
            print("snap2key \(snap2.key)")
            DataService.rootRef.child("images").child(snap2.key).observeEventType(.Value , withBlock: { (snap) in
                
                print("imagekey \(snap.key)")
                if let image = Image.init(snapshot: snap){
                    username.images.append(image)
                    self.feedTableView.reloadData()
                }
                
            })
            
            
        })
        /**end of andre*/
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return usernameForFeed.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed("Sections", owner: 0, options: nil)[0] as? Sections
        
        view?.imageView.layer.cornerRadius = 20
        view?.imageView.backgroundColor = UIColor.grayColor()
        
        view?.usernameLabel.text = usernameForFeed[section].username
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userInfo = usernameForFeed[section]
        return userInfo.images.count
    }
    
    func documentPahth() -> String {
        return (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.absoluteString)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedTableViewCell
        let userInfo = usernameForFeed[indexPath.section]
        let oneImage = userInfo.images[indexPath.row]
        //        let oneImage = imagesForFeed[indexPath.row]
        cell?.imagePost.sd_setImageWithURL(NSURL(string: oneImage.downloadURL))
        

        cell?.delegate = self
        cell?.indexPath = indexPath

        return cell!
    }
    
    func itemLikeIndex(indexPath: NSIndexPath?) {
        guard let imageIndexPath = indexPath else { return }
        let oneImage = imagesForFeed[imageIndexPath.row]
        
        // Edit the image node
        var userLikes = oneImage.usersLikes
        
        // check if user never like image
        if userLikes.indexOf(User.currentUserUid) == nil {
            // like
            FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").setValue(oneImage.numberOfLikes+1)
            userLikes.append(User.currentUserUid)
            FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").setValue(userLikes)
        }
        
        
        // Edit the user node
        //FIRDatabase.database().reference().child("users").child(User.currentUserUid).child("imagesLikes").setValue(oneImage.imageID)
        DataService.userRef.child(User.currentUserUid).child("imagesLikes").updateChildValues([oneImage.imageID:true])
    }
    
    func itemDislikeIndex(indexPath: NSIndexPath?) {
        guard let imageIndexPath = indexPath else { return }
        let oneImage = imagesForFeed[imageIndexPath.row]
        var userLikes = oneImage.usersLikes
        
        // check if user has like image before
        if let index = userLikes.indexOf(User.currentUserUid) {
            // dislike
            FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").setValue(oneImage.numberOfLikes-1)
            FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").setValue(userLikes.removeAtIndex(index))
        }
    
         FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").setValue("")
        
         DataService.userRef.child(User.currentUserUid).child("imagesLikes").child(oneImage.imageID).removeValue()
        
    }

}
