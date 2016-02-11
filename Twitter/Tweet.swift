//
//  Tweet.swift
//  Twitter
//
//  Created by Brian Lee on 2/9/16.
//  Copyright © 2016 brianlee. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    let user: User?
    let text: String?
    let createdAtString: String?
    let createdAt: NSDate?
    var favoritedCount: Int?
    var favorited: Bool?
    var retweetedCount: Int?
    var retweeted: Bool?
    let id: Int?
    
    init(dictionary: NSDictionary){
        user = User(dictionary: (dictionary["user"] as! NSDictionary))
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        createdAt = formatter.dateFromString(createdAtString!)
        
        favoritedCount = dictionary["favorite_count"] as? Int
        retweetedCount = dictionary["retweet_count"] as? Int
        
        let idString = dictionary["id_str"] as? String
        id = Int(idString!)
        
        let retweet = dictionary["retweeted"] as? Int
        let favorite = dictionary["favorited"] as? Int
        if retweet == 1{
            retweeted = true
        }else{
            retweeted = false
        }
        if favorite == 1{
            favorited = true
        }else{
            favorited = false
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

}

extension NSDate {
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if weeksFrom(date)   > 0 {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
            return "\(month)/\(day)/\(year)"
        }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

