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
    var imageCache = SDImageCache(namespace: "nameSpaceImageCacheXPTO")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        <#code#>
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesForFeed.count
    }
    
    func documentPahth() -> String {
        return (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last?.absoluteString)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedTableViewCell
        let oneImage = imagesForFeed[indexPath.row]
        
        /**sergio code*/
        if (NSFileManager.defaultManager().fileExistsAtPath(documentPahth()+"image1.jpg")){
            
            let savedImage = UIImage(contentsOfFile: documentPahth()+"image1.jpg")
            cell?.imagePost?.image = savedImage
            
        } else {
        
            cell?.imagePost?.sd_setImageWithURL(NSURL(string: oneImage.downloadURL), placeholderImage: UIImage(named: "placeholder"), completed: { (image, error, cacheType, imageURL) in
                
                // save to directory
                    let filePath = self.documentPahth()
                    let imageData = UIImageJPEGRepresentation(image, 0.8)
                    NSFileManager.defaultManager().createFileAtPath(filePath+"image1.jpg", contents: imageData, attributes: nil)
        
            })
        }
         /*end of sergio code */
        
        
//        /**copy from internet**/
//        imageCache.queryDiskCacheForKey(oneImage.downloadURL, done: {(image: UIImage, cacheType: SDImageCacheType) -> Void in
//            if image {
//                completedBlock(image, nil)
//                // return block
//            }
//            else {
//                /////////
//                // *    Request Image
//                /////////
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
//                    SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: SDWebImageProgressiveDownload, progress: {(receivedSize: Int, expectedSize: Int) -> Void in
//                        
//                        }, completed: {(image: UIImage, data: NSData, error: NSError, finished: Bool) -> Void in
//                            if finished && image {
//                                /////////
//                                // *    Save Image
//                                /////////
//                                imageCacheProgram.storeImage(image, recalculateFromImage: false, imageData: data, forKey: key, toDisk: true)
//                                completedBlock(image, error)
//                            } //end if
//                    }) //end completed image:
//                    
//                }) //end completed SDWebImageDownloader
//            } //end else
//        }) //end queryDiskCacheForKey
        
            
                                
        
//        cell?.imagePost.sd_setImageWithURL(NSURL(string: oneImage.downloadURL))
        
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
