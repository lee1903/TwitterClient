//
//  TwitterClient.swift
//  Twitter
//
//  Created by Brian Lee on 2/8/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "ubr2M4Tu123z28yj799CiVG3d"
let twitterConsumerSecret = "9PDsxQdt2Zr8qwAVhvuyE0l3AgYekBDQzeLBwysAzHesTwtFiP"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")


class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        return Static.instance
    }
    
    func postTweet(params: NSDictionary?){
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            print("post successful")
            
            }, failure: { (operation, error) -> Void in
                print("post unsuccessful")
        })
    }
    
    func favoriteTweet(params: NSDictionary?){
        POST("1.1/favorites/create.json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            print("favorite successful")
            
            }, failure: { (operation, error) -> Void in
                print("favorite unsuccessful")
        })
    }
    
    func unfavoriteTweet(params: NSDictionary?){
        POST("1.1/favorites/destroy.json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            print("unfavorite successful")
            
            }, failure: { (operation, error) -> Void in
                print("unfavorite unsuccessful")
        })
    }
    
    func retweetTweet(params: NSDictionary?){
        let id = params!["id"] as! Int
        POST("1.1/statuses/retweet/\(id).json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            print("retweet successful")
            
            }, failure: { (operation, error) -> Void in
                print("retweet unsuccessful")
        })
    }
    
    func unretweetTweet(params: NSDictionary?){
        let id = params!["id"] as! Int
        POST("1.1/statuses/unretweet/\(id).json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            print("unretweet successful")
            
            }, failure: { (operation, error) -> Void in
                print("unretweet unsuccessful")
        })
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (operation, response) -> Void in
            
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            print(response)
            
            }, failure: { (operation, error) -> Void in
                completion(tweets: nil, error: error)
                print("retrieving timeline failed")
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        //Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user:nil, error: error)
        }
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("got the access token")
            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation, response) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation, error) -> Void in
                print("error getting user")
                self.loginCompletion?(user:nil, error: error)
            })
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user:nil, error: error)
        }
    }
}


