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
    var usernameForFeed = [String]()
    var imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "Sections", bundle: nil)
        feedTableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "Sections")
        
        self.usernameForFeed.append(User.currentUserName)

        
        DataService.rootRef.child("images").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let image = Image.init(snapshot: snapshot){
                self.imagesForFeed.append(image)
                self.feedTableView.reloadData()
            }

        })
        
        //self.imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")
        imageCache.maxCacheAge = 60*60*3 //seconds
        
        
    }
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= 0.0{
////            navigationController?.navigationBar.hidden = true
//        }else{
////            navigationController?.navigationBar.hidden = false
//        }
//    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return usernameForFeed.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return usernameForFeed[section]
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NSBundle.mainBundle().loadNibNamed("Sections", owner: 0, options: nil)[0] as? Sections
        view?.usernameLabel.text = "Test sections"
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesForFeed.count
    }
    
    func documentPahth() -> String {
        return (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.absoluteString)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedTableViewCell
        let oneImage = imagesForFeed[indexPath.row]
        cell?.imagePost.sd_setImageWithURL(NSURL(string: oneImage.downloadURL))
        
        /**sergio code*/
//        if (NSFileManager.defaultManager().fileExistsAtPath(documentPahth()+"image1.jpg")){
//            
//            let savedImage = UIImage(contentsOfFile: documentPahth()+"image1.jpg")
//            cell?.imagePost?.image = savedImage
//            
//        } else {
//        
//            cell?.imagePost?.sd_setImageWithURL(NSURL(string: oneImage.downloadURL), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, imageURL) in
//                
//                // save to directory
//                    let filePath = self.documentPahth()
//                    let imageData = UIImageJPEGRepresentation(image, 0.8)
//                    NSFileManager.defaultManager().createFileAtPath(filePath+"image1.jpg", contents: imageData, attributes: nil)
//        
//            })
//        }
        cell?.delegate = self
        cell?.indexPath = indexPath
        return cell!
    }
    
    
//    
//    func loadImage(urlString: String){
//        var imageCache = SDImageCache(namespace: "default")
//        imageCache.queryDiskCacheForKey(myCacheKey, done: {(image: UIImage) -> Void in
//            self.imagesForFeed.append(image)
//        })
//
//    }
    
    
    
//    func loadImage(urlString: String){
//        
//        let imageCache = NSCache()
//        
//        if let cachedImage = imageCache.objectForKey(urlString) as? UIImage {
//            imagesForFeed.append(cachedImage)
//            return
//        }
//        
//        let url = NSURL(string: urlString)
//        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                if let downloadedImage = UIImage(data: data!) {
//                    imageCache.setObject(downloadedImage, forKey: urlString)
//                    
//                    self.imagesForFeed.append(downloadedImage)
//                }
//            })
//        
//        }).resume()
//    }
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
