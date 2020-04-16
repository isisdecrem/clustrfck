//
//  User.swift
//  ClustrPlus
//
//  Created by Isis Decrem on 4/15/20.
//  Copyright © 2020 Isis Decrem. All rights reserved.
//

import Foundation
import Firebase

class User{
    let ref : DatabaseReference?
    var uId: String = ""
    var email: String = ""
    var schoolCode: String = ""
    
    init(uId: String, email: String, schoolCode: String) {
        self.ref = nil
        self.uId = uId
        self.email = email
        self.schoolCode = schoolCode
        
    }
    
    init?(snapshot : DataSnapshot){
        guard
            let value = snapshot.value as? [String : AnyObject],
            let fUId = value["User Id"] as? String,
            let fEmail = value["Email"] as? String,
            let fSchoolCode = value["School Code"] as? String
        else{
            return nil
        }
        self.ref = snapshot.ref
        self.uId = fUId
        self.email = fEmail
        self.schoolCode = fSchoolCode
    }
    
    func toAnyObject() -> Any{
        return["User Id" : uId,
            "Email": email,
                "School Code" : schoolCode
        ]
    }
    
}


