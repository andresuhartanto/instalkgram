//
//  CommentViewController.swift
//  instalkgram
//
//  Created by khong fong tze on 15/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import UIKit
import FirebaseDatabase


class CommentViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addCommentTxt: UITextField!
    var selectedImage : Image!
    var listOfComments = [UserComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource=self
        addCommentTxt.delegate=self
        loadComments()
        //print("selectedImage \(selectedImage.imageID)")
        
        
    }
    
    
    func loadComments() {
        //print("selectedImage \(selectedImage.imageID)")
        DataService.rootRef.child("images").child(selectedImage.imageID).child("comments").observeEventType(.ChildAdded, withBlock: {(snapcomments) in
            //print("snapcommentskey \(snapcomments.key)")
            DataService.rootRef.child("comments").child(snapcomments.key).observeEventType(.Value, withBlock: {(snap1) in
                //print("snapsnapcommentskey \(snapcomments.key)")
                if let comm = UserComment.init(snapshot: snap1){
                    self.listOfComments.append(comm)
                    self.tableView.reloadData()
                }
            })
        })

    }
    
    
    @IBAction func sendBtnPressed(sender: UIButton) {
        
        doSendMessage()
    }
    
    func doSendMessage() -> Bool {
        guard let comment = self.addCommentTxt.text else {return false}
        
        let commentDict = ["created_at":NSDate().timeIntervalSince1970,"userUID":User.currentUserUid, "text":comment, "imageUID":selectedImage!.imageID]
        
        let commentRef = DataService.rootRef.child("comments").childByAutoId()
        commentRef.setValue(commentDict)
        
        DataService.rootRef.child("images").child(selectedImage.imageID).child("comments").updateChildValues([commentRef.key:true])
        
        DataService.userRef.child(User.currentUserUid).child("comments").updateChildValues([commentRef.key:true])
        
        self.addCommentTxt.text=""
        self.addCommentTxt.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return doSendMessage()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as? CommentTableViewCell
        
        
        let oneComment = self.listOfComments[indexPath.row]
        
        cell?.commentTxtView.text = oneComment.text
        cell?.usernameLbl.text = "By " + oneComment.user.username + " at " + oneComment.displayDateTime()
        //cell?.userPhoto.image.sd_setImageWithURL(NSURL(string: oneComment.user.photo))
        
        return cell!
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //loadComments()
        self.tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfComments.count
    }
    
}
