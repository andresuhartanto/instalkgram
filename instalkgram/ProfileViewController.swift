//
//  ProfileViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, profileTapedDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var imageForPost = [Image]()
    var profilePhotoURL : String?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

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
        
        //.child("profile_photo").child("downloadURL")
        DataService.userRef.child(User.currentUserUid).child("profile_photo").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            print("photo \(snapshot.key)")
        
           
            if let photoURL = snapshot.value as? String {
                self.profilePhotoURL = photoURL
            }else {
                self.profilePhotoURL = ""
            }
//            let range = NSRange(location: 0, length: 1)
//            collectionView.reloadSections(NSIndexSet(indexesInRange: range
            let headerIndexPath = NSIndexPath(forItem: 0, inSection: 0)
            let header = self.collectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: headerIndexPath)
//            header.setNeedsLayout()
            header.setNeedsDisplay()
            
            self.collectionView.reloadData()
      
            
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! ProfileHeaderCollectionReusableView
        header.delegate = self
        header.setupTapGesture()
        header.profileImageView.layer.cornerRadius = header.profileImageView.frame.height/2
        header.profileImageView.layer.borderWidth = 2
        header.profileImageView.clipsToBounds = true
        
        if let photo = self.profilePhotoURL as String? {
            header.profileImageView.sd_setImageWithURL(NSURL(string:  photo))
        } else {
            header.profileImageView.image = UIImage(contentsOfFile: "background2")
        }
        
        return header
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
    
    
    func profileImageTapped(){
        //        imagePicker.allowsEditing = false
        //        imagePicker.sourceType = .PhotoLibrary
        //
        //        presentViewController(imagePicker, animated: true, completion: nil)
        //        print("image tapped")
    }
    
    
    
    func handleProfileTapped() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        print("tapped dsdfa")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            uploadProfilePicture(pickedImage)
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func uploadProfilePicture(pickedImage:UIImage){
        
        //store to Firebase Storage
        let imagesStorageRef = StorageService.storageRef.child("images")
        let imageData = UIImageJPEGRepresentation(pickedImage, 0.8)
        let imagePath = FIRAuth.auth()!.currentUser!.uid + ".jpg"
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
                
                let imageDict = ["profile_photo_url":fullurl]
                //build a new root node called tweets
                let imageRef = DataService.userRef.child(User.currentUserUid).child("profile_photo")
                //underneath the root, there is text,created_at,userUID
                imageRef.setValue(imageDict)
                
                // Caching the image
                SDImageCache.sharedImageCache().storeImage(pickedImage, forKey: fullurl)
                
                /**/
        }
        
    }
    
}
