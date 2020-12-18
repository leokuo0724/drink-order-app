//
//  OptionCheckCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OptionCheckCell: UITableViewCell {
    
    var option: AddOn?
    var isChecked: Bool = false
    
    let btn = UIButton()
    let label = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        label.frame = CGRect(x: 80, y: 0, width: UIScreen.main.bounds.width-80-36, height: 48)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "test"
        self.addSubview(label)
        
        btn.frame = CGRect(x: 48, y: 0, width: UIScreen.main.bounds.width-48, height: 48)
        btn.contentHorizontalAlignment = .leading
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "square"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(selectOption), for: .touchUpInside)
        self.addSubview(btn)
    }
    
    @objc func selectOption() {
        if !isChecked {
            btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            order.addOn.append(option!)
        } else {
            btn.setImage(UIImage(systemName: "square"), for: .normal)
            if let index = order.addOn.firstIndex(of: option!) {
                order.addOn.remove(at: index)
            }
        }
        isChecked = !isChecked
        NotificationCenter.default.post(name: NSNotification.Name("updateBrief"), object: nil)
    }
    
    override func layoutSubviews() {
        self.frame.size.height = 48
        label.text = option?.rawValue
    }

}
