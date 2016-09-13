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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var feedTableView: UITableView!
    var imagesForFeed = [Image]()
    var usernameForFeed = [InstallkgramUser]()
    var imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.userRef.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let username = InstallkgramUser.init(snapshot: snapshot){
                self.usernameForFeed.append(username)
                
                DataService.userRef.child(username.userUID).child("images").observeEventType(.ChildAdded , withBlock: { (snapshot) in
                    
                    print("key \(snapshot.key)")
                    DataService.rootRef.child("images").child(snapshot.key).observeEventType(.Value , withBlock: { (snap) in
                        
                        print("imagekey \(snap.key)")
                        if let image = Image.init(snapshot: snap){
                            username.images.append(image)
                                self.feedTableView.reloadData()
                        }
                        
                    })
                    
                })
            }
        
        
        })
        
//        for i in 0..<usernameForFeed.count {
//            if imagesForFeed[i].userUID = User.currentUserUid{
//                
//            }
//        }
        
//        DataService.userRef.child(User.currentUserUid).child("images").observeEventType(.ChildAdded , withBlock: { (snapshot) in
//            
//            
//            var personalImages = [Image]()
//            
//            print("key \(snapshot.key)")
//            DataService.rootRef.child("images").child(snapshot.key).observeEventType(.Value , withBlock: { (snap) in
//                print("imagekey \(snap.key)")
//                if let image = Image.init(snapshot: snap){
////                    self.imagesForFeed.append(image)
////                    personalImages.append(image)
////                    self.feedTableView.reloadData()
//                }
//                
//            })
//            
//        })


//        DataService.userRef.child(User.currentUserUid).child("following").observeEventType(.ChildAdded, withBlock: {(snap) in
//            DataService.rootRef.child("relation").child(snap.key).observeEventType(.ChildAdded, withBlock: {(snap1) in
//                
//                guard let relationdict = snap1.value as? [String:AnyObject] else { return }
//                
//                let following = relationdict["followingUserUID"] as? String
//                
//                DataService.userRef.child(following!).observeEventType(.ChildAdded, withBlock: { (snap2) in
//                    DataService.rootRef.child("images").child(snap2.key).observeEventType(.Value, withBlock: { (snapshot) in
//                        if let image = Image.init(snapshot: snapshot){
//                            self.imagesForFeed.append(image)
//                            self.feedTableView.reloadData()
//                        }
//                        
//                    })
//                    
//                    
//                })
//                
//            })
//            
//        })
        
        
        
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

}
