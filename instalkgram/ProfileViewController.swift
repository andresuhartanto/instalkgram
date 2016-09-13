//
//  ProfileViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var numberOfPost: UILabel!
    @IBOutlet weak var numberOfFollowers: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    var imageForPost = [Image]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = User.currentUserName
        
        DataService.rootRef.child("images").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let imagePost = Image.init(snapshot: snapshot){
                self.imageForPost.append(imagePost)
                self.collectionView.reloadData()
            }
        
        
        
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
        let LogInViewController = storyboard.instantiateViewControllerWithIdentifier("LoginVC")
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
    

}
