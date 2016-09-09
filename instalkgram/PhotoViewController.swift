//
//  PhotoViewController.swift
//  instalkgram
//
//  Created by Andre Suhartanto on 9/9/16.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import Fusuma

class PhotoViewController: UIViewController, FusumaDelegate {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let fusuma = FusumaViewController()
        fusuma.delegate = self
//        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.presentViewController(fusuma, animated: true, completion: nil)
    }
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(image: UIImage) {
        imageView.image = image
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    @IBAction func onShareButtonPressed(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "AfterLogin", bundle: NSBundle.mainBundle())
        let ChatListViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarVC")
        self.presentViewController(ChatListViewController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func onCancelButtonPressed(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "AfterLogin", bundle: NSBundle.mainBundle())
        let ChatListViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarVC")
        self.presentViewController(ChatListViewController, animated: true, completion: nil)
        
        
    }
    

}
