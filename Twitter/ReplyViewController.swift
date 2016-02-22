//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/17/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    var tweet: Tweet?
    let limitLength = 140
    var numCharactersLeft = 140

    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var inReplyToLabel: UILabel!
    @IBOutlet weak var replyContentView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inReplyToLabel.text = "In reply to " + tweet!.user!.name!
        
        numCharactersLeft = 140 - tweet!.user!.screenname!.characters.count - 2
        characterCountLabel.text = "\(numCharactersLeft)"
        
        replyContentView.textColor = UIColor.blackColor()
        
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        replyContentView.delegate = self
        replyContentView.textAlignment = NSTextAlignment.Left
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        
        replyContentView.text = "@" + tweet!.user!.screenname! + " "
        
        replyContentView.becomeFirstResponder()
        
        replyContentView.selectedTextRange = replyContentView.textRangeFromPosition(replyContentView.beginningOfDocument, toPosition: replyContentView.beginningOfDocument)
        
        let pos = replyContentView.positionFromPosition(replyContentView.beginningOfDocument, offset: tweet!.user!.screenname!.characters.count+2)
        
        replyContentView.selectedTextRange = replyContentView.textRangeFromPosition(pos!, toPosition: pos!)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        numCharactersLeft = 140 - replyContentView.text.characters.count
        characterCountLabel.text = "\(numCharactersLeft)"
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: NSString = replyContentView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        if !updatedText.containsString("@" + tweet!.user!.screenname!) {
            numCharactersLeft = 140 - tweet!.user!.screenname!.characters.count - 2
            characterCountLabel.text = "\(numCharactersLeft)"
            
            replyContentView.text = "@" + tweet!.user!.screenname! + " "
            
            let pos = replyContentView.positionFromPosition(replyContentView.beginningOfDocument, offset: tweet!.user!.screenname!.characters.count+2)
            
            replyContentView.selectedTextRange = replyContentView.textRangeFromPosition(pos!, toPosition: pos!)
            
            return replyContentView.text.characters.count + (text.characters.count - range.length) <= 140
        }
        
        return replyContentView.text.characters.count + (text.characters.count - range.length) <= 140
    }

    
    @IBAction func onPost(sender: AnyObject) {
        let content = replyContentView.text!
        let id = tweet!.id!
        let param = ["status": content, "in_reply_to_status_id": id]
        
        TwitterClient.sharedInstance.postTweet(param)
        TwitterClient.sharedInstance.toRefresh = true
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
