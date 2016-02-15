//
//  CreateTweetViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/11/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    let limitLength = 140
    var numCharactersLeft = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@" + (User.currentUser?.screenname)!
        
        let url = NSURL(string: (User.currentUser?.profileImageURL)!)
        profileImageView.setImageWithURL(url!)
        
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tweetTextView.delegate = self
        tweetTextView.textAlignment = NSTextAlignment.Left
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        
        tweetTextView.text = "What's happening?"
        tweetTextView.textColor = UIColor.lightGrayColor()
        
        tweetTextView.becomeFirstResponder()
        
        tweetTextView.selectedTextRange = tweetTextView.textRangeFromPosition(tweetTextView.beginningOfDocument, toPosition: tweetTextView.beginningOfDocument)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        numCharactersLeft = 140 - tweetTextView.text.characters.count
        characterCountLabel.text = "\(numCharactersLeft)"
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: NSString = tweetTextView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            numCharactersLeft = 140
            characterCountLabel.text = "\(numCharactersLeft)"
            
            tweetTextView.text = "What's happening?"
            tweetTextView.textColor = UIColor.lightGrayColor()
            
            tweetTextView.selectedTextRange = tweetTextView.textRangeFromPosition(tweetTextView.beginningOfDocument, toPosition: tweetTextView.beginningOfDocument)
            
            return tweetTextView.text.characters.count + (text.characters.count - range.length) <= 140
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if tweetTextView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            tweetTextView.text = nil
            tweetTextView.textColor = UIColor.blackColor()
        }
        
        return tweetTextView.text.characters.count + (text.characters.count - range.length) <= 140
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if tweetTextView.textColor == UIColor.lightGrayColor() {
                tweetTextView.selectedTextRange = tweetTextView.textRangeFromPosition(tweetTextView.beginningOfDocument, toPosition: tweetTextView.beginningOfDocument)
            }
        }
    }

    @IBAction func onCancel(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    @IBAction func onPost(sender: AnyObject) {
        let content = tweetTextView.text!
        let param = ["status": content]
        
        TwitterClient.sharedInstance.postTweet(param)
        TwitterClient.sharedInstance.toRefresh = true
        
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
