//
//  PhotoViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import Fusuma
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class PhotoViewController: UIViewController, FusumaDelegate {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fusuma = FusumaViewController()
        fusuma.delegate = self
//        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(image: UIImage) {
        imageView.image = image
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    @IBAction func onShareButtonPressed(sender: UIButton) {
        
        //store to Firebase Storage
        if let selectedImage = imageView.image {
            let imagesStorageRef = StorageService.storageRef.child("images")
            let imageData = UIImageJPEGRepresentation(selectedImage, 0.8)
            let imagePath = FIRAuth.auth()!.currentUser!.uid +
                "/\(Int(NSDate.timeIntervalSinceReferenceDate() * 1000)).jpg"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            imagesStorageRef.child(imagePath)
                .putData(imageData!, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        print("Error uploading: \(error)")
                        return
                    }
                    /**save image to firebase database*/
                    let fullurl = metadata!.downloadURL()!.absoluteString
                    print("fulurl \(metadata!.downloadURL()!.absoluteString)")
                    let imageDict = ["downloadURL":fullurl,"created_at":NSDate().timeIntervalSince1970,"userUID":User.currentUserUid]
                    //build a new root node called tweets
                    let imageRef = DataService.rootRef.child("images").childByAutoId()
                    //underneath the root, there is text,created_at,userUID
                    imageRef.setValue(imageDict)
                    
                    //append new images.key inside "users.images"
                    DataService.userRef.child(User.currentUserUid).child("images").updateChildValues([imageRef.key:true])
                    
                    //add to the follower's feeds
                    DataService.userRef.child(User.currentUserUid).child("follower").observeEventType(.ChildAdded, withBlock: {(snapshot) in
                        DataService.userRef.child(User.currentUserUid).child("feeds").updateChildValues([imageRef.key:true])
                        DataService.userRef.child(snapshot.key).child("feeds").updateChildValues([imageRef.key:true])
                    })
                    
                    
                    // Caching the image
                    SDImageCache.sharedImageCache().storeImage(selectedImage, forKey: fullurl)
                    
                    /**/
            }
        }
        
        let storyboard = UIStoryboard(name: "AfterLogin", bundle: NSBundle.mainBundle())
        let ChatListViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarVC")
        self.presentViewController(ChatListViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "AfterLogin", bundle: NSBundle.mainBundle())
        let ChatListViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarVC")
        self.presentViewController(ChatListViewController, animated: true, completion: nil)
        
        
    }
    

}
