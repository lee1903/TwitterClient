//
//  TweetDetailCell.swift
//  Twitter
//
//  Created by Brian Lee on 2/10/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class TweetDetailCell: UITableViewCell {
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!

    
    var tweet: Tweet! {
        didSet{
            tweetLabel.text = tweet.text
            screenNameLabel.text = "@" + (tweet.user?.screenname)!
            nameLabel.text = tweet.user?.name
            
            let url = NSURL(string: (tweet.user?.profileImageURL)!)
            avatarImageView.setImageWithURL(url!)
            
            retweetLabel.text = "\(tweet.retweeted!)"
            favoriteLabel.text = "\(tweet.favorited!)"
            
            let dateOffset = NSDate().offsetFrom(tweet.createdAt!)
            timeLabel.text = dateOffset
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
