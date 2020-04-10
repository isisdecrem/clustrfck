//
//  Update.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/6/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import Foundation
import Firebase
class Update{
    let ref: DatabaseReference?
    var clubId: Int = 0
    var title: String = ""
    var update: String = ""
    
    init(clubId: Int, title: String, update: String) {
        self.ref = nil
        self.clubId = clubId
        self.title = title
        self.update = update
    }
    
    init?(snapshot: DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let fClubId = value["Club Id"] as? Int,
            let fTitle = value["Update Title"] as? String,
            let fUpdate = value["Update Info"] as? String
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.clubId = fClubId
        self.title = fTitle
        self.update = fUpdate
    }
    
    func toAnyObject() -> Any {
        return[
            "Club Id" : clubId,
            "Update Title" : title,
            "Update Info" : update
        
        ]
        
    }
}
    
    

