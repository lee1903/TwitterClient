//
//  DetailViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/11/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController {

    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = tweet!.text
        screenNameLabel.text = "@" + (tweet!.user?.screenname)!
        nameLabel.text = tweet!.user?.name
        
        let url = NSURL(string: (tweet!.user?.profileImageURL)!)
        avatarImageView.setImageWithURL(url!)
        
        let date = NSDate().toString(tweet!.createdAt!)
        dateLabel.text = date
        
        favoriteCountLabel.text = "\(tweet!.favoritedCount!)"
        retweetCountLabel.text = "\(tweet!.retweetedCount!)"
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        if (tweet!.retweeted == false){
            retweetButton.setImage(UIImage(named: "RetweetIcon.png"), forState: .Normal)
        }else{
            retweetButton.setImage(UIImage(named: "RetweetIconPressed.png"), forState: .Normal)
        }
        if (tweet!.favorited == false){
            favoriteButton.setImage(UIImage(named: "LikeIcon.png"), forState: .Normal)
        }else{
            favoriteButton.setImage(UIImage(named: "LikeIconPressed.png"), forState: .Normal)
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("avatarImageTapped:"))
        avatarImageView.userInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    func avatarImageTapped(sender: AnyObject){
        self.performSegueWithIdentifier("fromDetailtoProfileSegue", sender: sender)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let id = tweet!.id!
        let param = ["id": id]
        if tweet!.favorited == false{
            TwitterClient.sharedInstance.favoriteTweet(param)
            tweet!.favoritedCount!++
            tweet!.favorited = true
            favoriteButton.setImage(UIImage(named: "LikeIconPressed.png"), forState: .Normal)
        } else{
            TwitterClient.sharedInstance.unfavoriteTweet(param)
            tweet!.favoritedCount!--
            tweet!.favorited = false
            favoriteButton.setImage(UIImage(named: "LikeIcon.png"), forState: .Normal)
        }
        favoriteCountLabel.text = "\(tweet!.favoritedCount!)"
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        let id = tweet!.id!
        let param = ["id": id]
        if tweet!.retweeted == false{
            TwitterClient.sharedInstance.retweetTweet(param)
            tweet!.retweetedCount!++
            tweet!.retweeted = true
            retweetButton.setImage(UIImage(named: "RetweetIconPressed.png"), forState: .Normal)
        } else{
            TwitterClient.sharedInstance.unretweetTweet(param)
            tweet!.retweetedCount!--
            tweet!.retweeted = false
            retweetButton.setImage(UIImage(named: "RetweetIcon.png"), forState: .Normal)
        }
        retweetCountLabel.text = "\(tweet!.retweetedCount!)"
    }
    
    @IBAction func onReply(sender: AnyObject) {
        self.performSegueWithIdentifier("DetailReplySegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fromDetailtoProfileSegue"{
            let viewController  = segue.destinationViewController as! UserProfileViewController
            viewController.user = tweet!.user!
        } else if segue.identifier == "DetailReplySegue"{
            let viewController  = segue.destinationViewController as! ReplyViewController
            viewController.tweet = tweet!
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
