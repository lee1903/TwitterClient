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
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!

    @IBOutlet weak var favoriteButton2: UIButton!
    @IBOutlet weak var retweetButton2: UIButton!
    @IBOutlet weak var replyButton2: UIButton!
    
    @IBOutlet weak var retweetedStatusView: UIView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            if retweetedStatusView != nil{
                if tweet.retweetedBy != nil{
                    retweetedStatusView.hidden = false
                    retweetedByLabel.text = (tweet.retweetedBy)! +  " Retweeted"
                } else{
                    retweetedStatusView.hidden = true
                }
            }
            
            tweetLabel.text = tweet.text
            screenNameLabel.text = "@" + (tweet.user?.screenname)!
            nameLabel.text = tweet.user?.name
            
            let url = NSURL(string: (tweet.user?.profileImageURL)!)
            avatarImageView.setImageWithURL(url!)
            
            retweetLabel.text = "\(tweet.retweetedCount!)"
            favoriteLabel.text = "\(tweet.favoritedCount!)"
            
            let dateOffset = NSDate().offsetFrom(tweet.createdAt!)
            timeLabel.text = dateOffset
            
            if (tweet.retweeted == false){
                retweetButton.setImage(UIImage(named: "RetweetIcon.png"), forState: .Normal)
            }else{
                retweetButton.setImage(UIImage(named: "RetweetIconPressed.png"), forState: .Normal)
            }
            if (tweet.favorited == false){
                favoriteButton.setImage(UIImage(named: "LikeIcon.png"), forState: .Normal)
            }else{
                favoriteButton.setImage(UIImage(named: "LikeIconPressed.png"), forState: .Normal)
            }
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
