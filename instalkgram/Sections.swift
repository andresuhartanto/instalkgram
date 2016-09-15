//
//  SectionsViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/13/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

protocol userTapedDelegate: class {
    func handleUserTapped(Sender: Sections)
}

class Sections: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var userUID: String?
    var username: String?
    var delegate: userTapedDelegate?
    

    func setupTapGesture(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction(_:)))
        usernameLabel.userInteractionEnabled = true
        usernameLabel.gestureRecognizers = [tap]
    }
    
    
    func tapFunction(sender: UITapGestureRecognizer) {
        
        delegate?.handleUserTapped(self)
        
    }
    
}
