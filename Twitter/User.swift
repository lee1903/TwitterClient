//
//  User.swift
//  Twitter
//
//  Created by Brian Lee on 2/9/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
let didcancel = "didcancel"

class User: NSObject {
    let name: String?
    let screenname: String?
    let profileImageURL: String?
    let tagline: String?
    let dictionary: NSDictionary
    let tweetCount: Int?
    let followerCount: Int?
    let followingCount: Int?
    let backgroundImageURL: String?
    let bio: String?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        tweetCount = dictionary["statuses_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        backgroundImageURL = dictionary["profile_banner_url"] as? String
        bio = dictionary["description"] as? String
        print(dictionary)
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get{
            if _currentUser == nil{
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil{
                    do{
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue:0)) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch{
                        print("error reading json")
                    }
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            if _currentUser != nil{
                do{
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: NSJSONWritingOptions(rawValue:0))
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch{
                    print("error writing json")
                }
            } else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
