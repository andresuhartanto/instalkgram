//
//  RelationshipTableViewCell.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

protocol RelationshipTableViewCellDelegate: class {
    
    func handleFollower(sender: RelationshipTableViewCell, followStatus:Bool)
    
}

class RelationshipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var followStatus = false
    
    weak var delegate:RelationshipTableViewCellDelegate?
    
    
    @IBAction func onFollowingBtnPressed(sender: UIButton) {
        
        if followBtn.titleLabel?.text=="+Following" {
            self.followStatus=true
            //followBtn.titleLabel?.text="Followed"
        } else {
            self.followStatus=false
            //followBtn.titleLabel?.text="+Following"
        }
        
        delegate?.handleFollower(self,followStatus: self.followStatus)
    }
    
}
