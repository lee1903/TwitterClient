//
//  CreateTweetViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/11/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class CreateTweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    let limitLength = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        tweetTextView.delegate = self
        tweetTextView.textAlignment = NSTextAlignment.Left
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        
        tweetTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
