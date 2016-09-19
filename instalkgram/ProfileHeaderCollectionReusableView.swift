//
//  ProfileHeaderCollectionReusableView.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/15/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

protocol profileTapedDelegate: class {
    func handleProfileTapped()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var numberOfPost: UILabel!
    @IBOutlet weak var numberOfFollower: UILabel!
    @IBOutlet weak var numberOfFollowing: UILabel!
    
    var delegate: profileTapedDelegate?
    
    
    func setupTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(_:)))
        profileImageView.userInteractionEnabled = true
        profileImageView.gestureRecognizers = [tap]
    }
    
    func tapFunction(sender : UITapGestureRecognizer) {
        print("tapped")
        delegate?.handleProfileTapped()
        
        
    }
}
