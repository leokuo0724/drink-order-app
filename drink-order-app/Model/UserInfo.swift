//
//  UserInfo.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import Foundation

class UserInfo {
    let userName: String
    let userGroup: String
    let editCode: String
    
    init(userName: String,
         userGroup: String,
         editCode: String) {
        self.userName = userName
        self.userGroup = userGroup
        self.editCode = editCode
    }
}
