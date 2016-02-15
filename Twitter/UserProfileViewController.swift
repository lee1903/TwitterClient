//
//  UserProfileViewController.swift
//  Twitter
//
//  Created by Brian Lee on 2/12/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    var user: User?

    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenNameLabel.text = "@" + user!.screenname!
        nameLabel.text = user!.name
        
        let url = NSURL(string: (user?.profileImageURL)!)
        avatarImageView.setImageWithURL(url!)
        
        if user?.backgroundImageURL != nil{
            let backgroundurl = NSURL(string: (user?.backgroundImageURL)!)
            backgroundImageView.setImageWithURL(backgroundurl!)
        }
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.whiteColor().CGColor
        avatarImageView.clipsToBounds = true
        
        tweetsCountLabel.text = "\(user!.tweetCount!)"
        followersCountLabel.text = "\(user!.followerCount!)"
        followingCountLabel.text = "\(user!.followingCount!)"
        if user!.bio != nil{
            bioLabel.text = user!.bio!
        }

        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 172/255, blue: 237/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        print(user!.name!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
