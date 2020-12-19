//
//  GroupCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/19.
//

import UIKit

class GroupCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func selectAction() {
        userInfo.userGroup = self.textLabel!.text!
        print(userInfo.userGroup)
        // pop up 縮回
        NotificationCenter.default.post(name: NSNotification.Name("hideGroupSelection"), object: nil)
    }

}
