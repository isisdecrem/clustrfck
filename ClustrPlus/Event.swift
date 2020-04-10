//
//  Event.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/1/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import Foundation
import Firebase

class Event{
    let ref: DatabaseReference?
    var clubId: Int = 0
    var title: String = ""
    var date: String = ""
    var time: String = ""
    var location: String = ""
    var extra: String = ""
    
    init(clubId: Int, title: String, date: String, time: String, location: String, extra: String) {
        self.ref = nil
        self.clubId = clubId
        self.title = title
        self.date = date
        self.time = time
        self.location = location
        self.extra = extra
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let fClubId = value["Club Id"] as? Int,
            let fTitle = value["Event Title"] as? String,
            let fDate = value["Event Date"] as? String,
            let fTime = value["Event Time"] as? String,
            let fLocation = value["Event Location"] as? String,
            let fExtra = value["Event Extra"] as? String
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.clubId = fClubId
        self.title = fTitle
        self.date = fDate
        self.time = fTime
        self.location = fLocation
        self.extra = fExtra
    }
    
    func toAnyObject() -> Any {
        return[
            "Club Id" : clubId,
            "Event Title" : title,
            "Event Date" : date,
            "Event Time" : time,
            "Event Location" : location,
            "Event Extra" : extra
        
        ]
        
    }
    
}
