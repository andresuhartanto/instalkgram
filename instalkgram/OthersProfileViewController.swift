//
//  OthersProfileViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/15/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth

class OthersProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userID: String = ""
    var username: String = ""
    var imafeForPost = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = username
        self.collectionView.backgroundColor = UIColor.whiteColor()
        

        DataService.userRef.child(userID).child("images").observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            DataService.rootRef.child("images").child(snapshot.key).observeEventType(.Value, withBlock: {(snap1) in
            if let image = Image.init(snapshot: snap1){
                self.imafeForPost.append(image)
                self.collectionView.reloadData()
            }
                
            })
        })
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imafeForPost.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? OthersProfileCollectionViewCell
        
        let image = imafeForPost[indexPath.row]
        
        cell?.postImageView.sd_setImageWithURL(NSURL(string: image.downloadURL))
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = self.view.frame.size.width / 3
        return CGSizeMake(width, width)
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as! HeaderCollectionReusableView
        
        return header
    }
    
    
    
    
    


}
