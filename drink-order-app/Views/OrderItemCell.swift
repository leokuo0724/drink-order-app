//
//  OrderItemCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OrderItemCell: UITableViewCell {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var ordererLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        nameLabel.textColor = .white
        briefLabel.textColor = .white
        briefLabel.alpha = 0.5
        ordererLabel.textColor = .white
        ordererLabel.alpha = 0.5
        priceLabel.textColor = .white
    }

}
