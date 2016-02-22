
//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/12/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User?
    var tweets: [Tweet]?

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        
        navigationController?.navigationBar.hidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        
        if user == nil{
            user = User.currentUser
            backButton.hidden = true
        }
        
        screenNameLabel.text = "@" + user!.screenname!
        nameLabel.text = user!.name
        
        let url = NSURL(string: (user?.profileImageURL)!)
        avatarImageView.setImageWithURL(url!)
        
        if user?.backgroundImageURL != nil{
            let backgroundurl = NSURL(string: (user?.backgroundImageURL)!)
            backgroundImageView.setImageWithURL(backgroundurl!)
        }else{
            let color = UIColor(red: 79/255, green: 104/255, blue: 1, alpha: 1)
            let size = CGSize(width: 300, height: 300)
            let image = getImageWithColor(color, size: size)
            backgroundImageView.image = image
        }
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.clipsToBounds = true
        
        tweetsCountLabel.text = formatInt(user!.tweetCount!)
        followersCountLabel.text = formatInt(user!.followerCount!)
        followingCountLabel.text = formatInt(user!.followingCount!)
        if user!.bio != nil{
            bioLabel.text = user!.bio!
        }

        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let param = ["screen_name": user!.screenname!]
        TwitterClient.sharedInstance.userTimelineWithParams(param, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetDetailCell", forIndexPath: indexPath) as! TweetDetailCell
        
        cell.tweet = tweets![indexPath.row]
        cell.retweetButton2.addTarget(self, action: "retweetButtonPressed:", forControlEvents: .TouchUpInside)
        cell.retweetButton2.tag = indexPath.row
        
        cell.favoriteButton2.addTarget(self, action: "favoriteButtonPressed:", forControlEvents: .TouchUpInside)
        cell.favoriteButton2.tag = indexPath.row
        
        cell.replyButton2.addTarget(self, action: "replyButtonPressed:", forControlEvents: .TouchUpInside)
        cell.replyButton2.tag = indexPath.row
        
        if backButton.hidden == true{
            cell.selectionStyle = .None
        }
        
        return cell
    }
    
    func replyButtonPressed(sender: UIButton){
        self.performSegueWithIdentifier("userReplySegue", sender: tweets![sender.tag])
    }
    
    func retweetButtonPressed(sender: UIButton){
        let tweet = tweets![sender.tag]
        let id = tweet.id!
        let param = ["id": id]
        if tweet.retweeted == false{
            TwitterClient.sharedInstance.retweetTweet(param)
            tweet.retweetedCount!++
            tweet.retweeted = true
        } else{
            TwitterClient.sharedInstance.unretweetTweet(param)
            tweet.retweetedCount!--
            tweet.retweeted = false
        }
        tableView.reloadData()
    }
    
    func favoriteButtonPressed(sender: UIButton){
        let tweet = tweets![sender.tag]
        let id = tweet.id!
        let param = ["id": id]
        if tweet.favorited == false{
            TwitterClient.sharedInstance.favoriteTweet(param)
            tweet.favoritedCount!++
            tweet.favorited = true
        } else{
            TwitterClient.sharedInstance.unfavoriteTweet(param)
            tweet.favoritedCount!--
            tweet.favorited = false
        }
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func onBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userReplySegue"{
            let viewController  = segue.destinationViewController as! ReplyViewController
            let tweet = sender as! Tweet
            viewController.tweet = tweet
        } else if segue.identifier == "ProfileTweetDetailSegue"{
            let viewController  = segue.destinationViewController as! DetailViewController
            let tweet = sender as! Tweet
            viewController.tweet = tweet
        }
        
    }

    
    func formatInt(num: Int) -> String{
        var result = 0
        if num > 1000000{
            result = num/1000000
            return "\(result)M"
        } else if num > 1000{
            result = num/1000
            return "\(result)K"
        }
        return "\(num)"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if backButton.hidden == false{
            self.performSegueWithIdentifier("ProfileTweetDetailSegue", sender: tweets![indexPath.row])
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let param = ["screen_name": user!.screenname!]
        TwitterClient.sharedInstance.userTimelineWithParams(param, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
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
