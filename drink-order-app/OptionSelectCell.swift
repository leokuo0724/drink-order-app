//
//  OptionSelectCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/16.
//

import UIKit

class OptionSelectCell: UITableViewCell {
    
    var optionType: OptionType?
    var option: Any?
    
    let btn = UIButton()
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn.frame = CGRect(x: 36, y: 0, width: 48, height: 48)
        btn.tintColor = .white
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.setTitle("", for: .normal)
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(selectOption), for: .touchUpInside)
        self.addSubview(btn)
        
        label.frame = CGRect(x: 80, y: 0, width: UIScreen.main.bounds.width-80-36, height: 48)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "test"
        self.addSubview(label)
    }
    
    @objc func selectOption() {
        if let optionType = optionType,
           let option = option {
            switch optionType {
            case .temp:
                order.drinkTemp = option as? Temp
                NotificationCenter.default.post(name: NSNotification.Name("clearTempCellStyle"), object: nil)
            case .sugar:
                order.drinkSugar = option as? Sugar
                NotificationCenter.default.post(name: NSNotification.Name("clearSugarCellStyle"), object: nil)
            case .size:
                order.drinkSize = option as? Size
                NotificationCenter.default.post(name: NSNotification.Name("clearSizeCellStyle"), object: nil)
            default:
                break
            }
        }
        setBtnStyle(isActive: true)
        print(order.drinkTemp)
        print(order.drinkSugar)
        print(order.drinkSize)
    }
    
    func setBtnStyle(isActive: Bool) {
        if isActive {
            btn.setImage(UIImage(systemName: "record.circle"), for: .normal)
        } else {
            btn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        self.frame.size.height = 48
        
        if let optionType = optionType,
           let option = option {
            switch optionType {
            case .temp:
                label.text = (option as! Temp).rawValue
            case .sugar:
                label.text = (option as! Sugar).rawValue
            case .size:
                label.text = (option as! Size).rawValue
            default:
                break
            }
        }
        
    }
    
}
