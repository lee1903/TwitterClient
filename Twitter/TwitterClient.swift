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
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        return Static.instance
    }

}
