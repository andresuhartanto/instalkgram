//
//  FeedTableViewCell.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseDatabase
@objc protocol TableViewCellDelegate {
    func itemLikeIndex(indexPath: NSIndexPath?)
    func itemDislikeIndex(indexPath: NSIndexPath?)
}

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    weak var delegate: TableViewCellDelegate?
    var indexPath: NSIndexPath?
    var liked:Bool = true
    
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
    
        
        
        if liked{
            

            delegate?.itemLikeIndex(indexPath)
            let image = UIImage(named: "love_filled")
            likeButtonImage.setImage(image, forState: .Normal)
            print("like button pressed")
            liked = false
            
        }else{
            delegate?.itemDislikeIndex(indexPath)
            let image = UIImage(named: "love_empty")
            likeButtonImage.setImage(image, forState: .Normal)
            liked = true
            
        }
        
        
        
        
    }
    
    
    
    
    @IBAction func onCommentButtonPressed(sender: UIButton) {
        print("comment button pressed")
    }
    
}
