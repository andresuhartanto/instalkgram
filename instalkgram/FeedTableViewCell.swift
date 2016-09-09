//
//  FeedTableViewCell.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
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
        let image = UIImage(named: "love_filled")
        likeButtonImage.setImage(image, forState: .Normal)
        print("like button pressed")
    }

    @IBAction func onCommentButtonPressed(sender: UIButton) {
        print("comment button pressed")
    }
    
}
