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


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, userTapedDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var feedTableView: UITableView!
    var imagesForFeed = [Image]()
    var usernameForFeed = [InstallkgramUser]()
    var imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")

    var selectedImage : Image?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.retrieveCurrentUser(User.currentUserUid)
        self.retrieveFollowedUsersImages()
        


    }
    
    
    func retrieveCurrentUser(userID: String){
        
//        DataService.userRef.child(userID).observeSingleEventOfType(.Value, withBlock: {(snapself) in
//            
//            print("snapselfkey \(snapself.key)")
//            
//            if let currentUser = InstallkgramUser.init(snapshot: snapself){
//                self.usernameForFeed.append(currentUser)
//                self.retrieveFeed(currentUser)
//                
//                //to cater - user come here without login (did not sign out in previous session)
//                User.getSingleton.storeUserSession(currentUser.username)
//            }
//        })

        
        DataService.userRef.child(User.currentUserUid).observeSingleEventOfType(.Value, withBlock: {(snapself) in
            //print("snapselfkey \(snapself.key)")
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
            //print("snapshotkey \(snapshot.key)")
            
            DataService.userRef.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: {(snap1) in
                
                //print("snap1key \(snap1.key)")
                
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
            

            DataService.rootRef.child("images").child(snap2.key).observeSingleEventOfType(.Value , withBlock: { (snap) in
                
                //print("imagekey \(snap.key)")
                if let image = Image.init(snapshot: snap){
                    print("username.username \(username.username)")
                    image.userName = username.username
                    //image.numberOfLikes=
                    username.images.append(image)
                    self.imagesForFeed.append(image)
                    self.feedTableView.reloadData()
                }
                
            })
            
        })
        /**end of andre*/
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return imagesForFeed.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed("Sections", owner: 0, options: nil)[0] as? Sections
        view?.setupTapGesture()
        view?.imageView.layer.cornerRadius = 20
        view?.imageView.backgroundColor = UIColor.grayColor()
        
        let image = imagesForFeed[section]
        view?.userUID =  image.userUID //usernameForFeed[section].userUID
        view?.usernameLabel.text = image.userName //usernameForFeed[section].username
        view?.username = image.userName
        view?.delegate = self
        return view
    }
    
    func handleUserTapped(Sender: Sections) {
        performSegueWithIdentifier("UserSegue", sender: Sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier=="CommentSegue" {
            let commentVC = segue.destinationViewController as! CommentViewController
            commentVC.selectedImage = selectedImage
        }
            
        else {
            let destinantion = segue.destinationViewController as! OthersProfileViewController
            let sections = sender as! Sections
            destinantion.userID = sections.userUID!
            destinantion.username = sections.username!
            print(sections.username)
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //        let userInfo = usernameForFeed[section]
        //        return userInfo.images.count
    }
    
    func documentPahth() -> String {
        return (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.absoluteString)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedTableViewCell
        //        let userInfo = usernameForFeed[indexPath.section]
        let oneImage = imagesForFeed[indexPath.section]
        //let oneImage = imagesForFeed[indexPath.row]
        cell?.imagePost.sd_setImageWithURL(NSURL(string: oneImage.downloadURL))

        cell?.imageObject = oneImage
        cell?.likesLabel.text = String(oneImage.numberOfLikes) + " Likes"


        
        cell?.delegate = self
        cell?.indexPath = indexPath
        
        
        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").observeEventType(.Value, withBlock : { (snapshot) in
                        if let numberOfLIkes = snapshot.value as? Int {
                            cell?.likesLabel.text = String(numberOfLIkes) + " Likes"
                        }
                    })
        
        return cell!
    }
    
//    func itemLikeIndex(indexPath: NSIndexPath?) {
//        //guard let imageIndexPath = indexPath else { return }
//        let userInfo = usernameForFeed[indexPath!.section]
//        let oneImage = userInfo.images[indexPath!.row]
//        
//        
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").observeEventType(.Value, withBlock : { (snapshot) in
//            if let numberOfLIkes = snapshot.value as? Int {
//                cell?.likesLabel.text = String(numberOfLIkes) + " Likes"
//            }
//        })
//        
//
//        
//        
//
//        return cell!
//    }
//
//    func numberOfLikesChanged(indexPath: NSIndexPath?) {
//        guard let theIndexPath = indexPath else { return }
//        feedTableView.reloadRowsAtIndexPaths([indexPath, withRowAnimation: .None)
//    }
    
//    func itemLikeIndex(indexPath: NSIndexPath?) {
//        //guard let imageIndexPath = indexPath else { return }
//        let userInfo = usernameForFeed[indexPath!.section]
//        let oneImage = userInfo.images[indexPath!.row]
//        
//        // Edit the image node
//        //var userLikes = oneImage.usersLikes
//        
//        // check if user never like image
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").child(User.currentUserUid).observeSingleEventOfType(.Value, withBlock: {snapshot in
//            // snapshot.value is "true" if user has liked this image before
//            if snapshot.value is NSNull {
//                FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").setValue(oneImage.numberOfLikes+1)
//                FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").updateChildValues([User.currentUserUid : true])
//                DataService.userRef.child(User.currentUserUid).child("imagesLikes").updateChildValues([oneImage.imageID:true])
//                //} else {
//                
//            }
//        })
//    }
//    
//    func itemDislikeIndex(indexPath: NSIndexPath?) {
//        //guard let imageIndexPath = indexPath else { return }
//        let userInfo = usernameForFeed[indexPath!.section]
//        let oneImage = userInfo.images[indexPath!.row]
//        //var userLikes = oneImage.usersLikes
//        
//        // check if user has like image before
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").setValue(oneImage.numberOfLikes-1)
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").child(User.currentUserUid).removeValue()
//        
//        
//        
//        DataService.userRef.child(User.currentUserUid).child("imagesLikes").child(oneImage.imageID).removeValue()
//        
//    }

//         check if user has like image before
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("numberOfLikes").setValue(oneImage.numberOfLikes-0)
//        FIRDatabase.database().reference().child("images").child(oneImage.imageID).child("userLikes").child(User.currentUserUid).removeValue()
//        
//        
//        
//        DataService.userRef.child(User.currentUserUid).child("imagesLikes").child(oneImage.imageID).removeValue()
//        
//    }

    func commentTheImage(indexPath:NSIndexPath?) {
        //let userInfo = usernameForFeed[indexPath!.section]
        //selectedImage = userInfo.images[indexPath!.row]
        selectedImage = imagesForFeed[indexPath!.section]
    }
    

    
}

