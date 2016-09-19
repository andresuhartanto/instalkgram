//
//  FeedTableViewCell.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseDatabase


class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
     
    
    var imageObject: Image?
    var indexPath: NSIndexPath?
   // var liked:Bool = true
    
    @IBOutlet weak var likeButtonImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    

    @IBAction func onLikeButtonPressed(sender: UIButton) {
        guard let imageObject = imageObject else { return }
        
        let imageRef = FIRDatabase.database().reference().child("images").child(imageObject.imageID)
        imageRef.child("userLikes").child(User.currentUserUid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let val = snapshot.value as? Bool{
                // liked already
                // lookat the current number of likes
                
                imageRef.child("numberOfLikes").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let numberOfLikes = snapshot.value as? Int{
                        imageRef.child("numberOfLikes").setValue(numberOfLikes - 1)
                        imageRef.child("userLikes").child(User.currentUserUid).removeValue()
                        let image = UIImage(named: "love_empty")
                        self.likeButtonImage.setImage(image, forState: .Normal)
                        
                    } else {
                    
                    }
                })
            } else {
                // not yet like
                imageRef.child("numberOfLikes").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let numberOfLikes = snapshot.value as? Int{
                        imageRef.child("numberOfLikes").setValue(numberOfLikes + 1)
                        imageRef.child("userLikes").child(User.currentUserUid).setValue(true)
                        let image = UIImage(named: "love_filled")
                        self.likeButtonImage.setImage(image, forState: .Normal)
                        
                    } else {
                        // never like this image before and numberOfLikes doesn't exist in database
                        // mark it as like
                        imageRef.child("numberOfLikes").setValue(1)
                        imageRef.child("userLikes").child(User.currentUserUid).setValue(true)
                        let image = UIImage(named: "love_filled")
                        self.likeButtonImage.setImage(image, forState: .Normal)
                    }
                })
            }
            
        })
       
        
//        if liked{
//            delegate?.itemLikeIndex(indexPath)
//            let image = UIImage(named: "love_filled")
//            likeButtonImage.setImage(image, forState: .Normal)
//            print("like button pressed")
//            liked = false
//            
//        }else{
//            
//            delegate?.itemDislikeIndex(indexPath)
//            let image = UIImage(named: "love_empty")
//            likeButtonImage.setImage(image, forState: .Normal)
//            liked = true
//            
//        }
        
        
        
        
    }
    
    
    
    
    @IBAction func onCommentButtonPressed(sender: UIButton) {
        print("comment button pressed")
    }
    
}
