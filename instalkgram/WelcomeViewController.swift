//
//  MainPageViewController.swift
//  instalkgram
//
//  Created by khong fong tze on 08/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.text = "Hello \(User.currentUserName)"
        
    }

    

}
