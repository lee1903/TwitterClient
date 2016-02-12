//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/10/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createTweetButton: UIButton!

    
    var tweets:[Tweet]?
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        createTweetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        let logo = UIImage(named: "TwitterIconNavBar.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    @IBAction func createTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("createTweetSegue", sender: self)
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
        cell.retweetButton.addTarget(self, action: "retweetButtonPressed:", forControlEvents: .TouchUpInside)
        cell.retweetButton.tag = indexPath.row
        
        cell.favoriteButton.addTarget(self, action: "favoriteButtonPressed:", forControlEvents: .TouchUpInside)
        cell.favoriteButton.tag = indexPath.row
        
        cell.selectionStyle = .None
        
        return cell
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
    
    func loadMoreData() {
        if tweets == nil{
            print("array is nil")
            return
        }
        let lastTweet = tweets!.last!
        let lastID = lastTweet.id!
        let param = ["max_id": lastID]
        TwitterClient.sharedInstance.homeTimelineWithParams(param, completion: { (var tweets, error) -> () in
            tweets?.removeFirst()
            self.tweets?.appendContentsOf(tweets!)
            self.tableView.reloadData()
            self.isMoreDataLoading = false
            self.loadingMoreView!.stopAnimating()
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
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
