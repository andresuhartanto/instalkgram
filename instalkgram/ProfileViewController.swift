//
//  ProfileViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var numberOfPost: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    var imageForPost = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture.layer.cornerRadius = 25
        self.navigationItem.title = User.currentUserName
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        DataService.userRef.child(User.currentUserUid).child("images").observeEventType(.ChildAdded , withBlock: { (snapshot) in
            
            //print("key \(snapshot.key)")
            DataService.rootRef.child("images").child(snapshot.key).observeEventType(.Value , withBlock: { (snap) in
                //print("imagekey \(snap.key)")
                if let image = Image.init(snapshot: snap){
                    self.imageForPost.append(image)
                    self.collectionView.reloadData()
                }
            
            })
        
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutButoon(sender: UIBarButtonItem) {
        
        try! FIRAuth.auth()!.signOut()
        User.getSingleton.removeUserSession()
        
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        let sureAction = UIAlertAction(title: "Sure", style: .Default) { (UIAlertAction) in
            self.goBackToLogin()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(sureAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func goBackToLogin(){
        let appDelegateTemp = UIApplication.sharedApplication().delegate!
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let LogInViewController = storyboard.instantiateInitialViewController()
        appDelegateTemp.window?!.rootViewController = LogInViewController
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageForPost.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? ProfileCollectionViewCell
        
        let oneImagePost = imageForPost[indexPath.row]
        
        cell?.postImage.sd_setImageWithURL(NSURL(string:  oneImagePost.downloadURL))
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let imageWidth = self.view.frame.size.width / 3
        return CGSizeMake(imageWidth, imageWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this image?", preferredStyle: .Alert)
        let okaAction = UIAlertAction(title: "Yes", style: .Default) { (okayAction) in
            
            if let imgDeleted = self.imageForPost[indexPath.row] as? Image {
                DataService.rootRef.child("images").child(imgDeleted.imageID).removeValue()
                DataService.userRef.child(User.currentUserUid).child("images").child(imgDeleted.imageID).removeValue()
                DataService.userRef.child(User.currentUserUid).child("feeds").child(imgDeleted.imageID).removeValue()
                
                //to do: to remove from firebase storage
                if (imgDeleted.filename != "") {
                    self.deleteImageFromStorage(imgDeleted)
                }
            
                self.imageForPost.removeAtIndex(indexPath.row)
                self.collectionView.reloadData()
            }
            
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        alert.addAction(okaAction)
        alert.addAction(dismissAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteImageFromStorage(imgDeleted: Image) {
        
        //print("filename \(imgDeleted.filename)")
        let imagesStorageRef = StorageService.storageRef.child("images/"+imgDeleted.filename)

        imagesStorageRef.deleteWithCompletion { (error) in
            if let error = error {
                //print("Error deleting: \(error)")
                return
            } else {
                //print("File deleted \(imgDeleted.filename)")
            }
        }
    }

}
