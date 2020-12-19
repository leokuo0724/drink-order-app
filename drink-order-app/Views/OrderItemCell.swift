//
//  OrderItemCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class OrderItemCell: UITableViewCell {
    
    var isDeleteShow: Bool = false
    var positionRecorder: [String : CGFloat] = [:]
    var editCode: String = ""
    var orderer: String = ""

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var ordererLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
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
        
        // 記錄UI位置最大最小值
        recordPos()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideDeleteBtn))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func recordPos() {
        positionRecorder["drinkImageViewMax"] = drinkImageView.frame.origin.x
        positionRecorder["drinkImageViewMin"] = drinkImageView.frame.origin.x - 96
        positionRecorder["nameLabelMax"] = nameLabel.frame.origin.x
        positionRecorder["nameLabelMin"] = nameLabel.frame.origin.x - 96
        positionRecorder["briefLabelMax"] = briefLabel.frame.origin.x
        positionRecorder["briefLabelMin"] = briefLabel.frame.origin.x - 96
        positionRecorder["ordererLabelMax"] = ordererLabel.frame.origin.x
        positionRecorder["ordererLabelMin"] = ordererLabel.frame.origin.x - 96
        positionRecorder["priceLabelMax"] = priceLabel.frame.origin.x
        positionRecorder["priceLabelMin"] = priceLabel.frame.origin.x - 96
        positionRecorder["deleteBtnMax"] = deleteBtn.frame.origin.x
        positionRecorder["deleteBtnMin"] = deleteBtn.frame.origin.x - 96
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let current = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            positionUpdate(distance: current.x - previous.x)
            
            if current.x == 0 {
                showDeleteBtn()
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if deleteBtn.frame.origin.x <= 414-96 {
            // 打開
            showDeleteBtn()
        } else {
            hideDeleteBtn()
        }
    }
    
    func positionUpdate(distance: CGFloat) {
        drinkImageView.frame.origin.x += distance
        nameLabel.frame.origin.x += distance
        briefLabel.frame.origin.x += distance
        ordererLabel.frame.origin.x += distance
        priceLabel.frame.origin.x += distance
        deleteBtn.frame.origin.x += distance
    }
    
    @objc func showDeleteBtn() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.drinkImageView.frame.origin.x = self.positionRecorder["drinkImageViewMin"]!
            self.nameLabel.frame.origin.x = self.positionRecorder["nameLabelMin"]!
            self.briefLabel.frame.origin.x = self.positionRecorder["briefLabelMin"]!
            self.ordererLabel.frame.origin.x = self.positionRecorder["ordererLabelMin"]!
            self.priceLabel.frame.origin.x = self.positionRecorder["priceLabelMin"]!
            self.deleteBtn.frame.origin.x = self.positionRecorder["deleteBtnMin"]!
        }
        isDeleteShow = true
    }
    
    @objc func hideDeleteBtn() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.drinkImageView.frame.origin.x = self.positionRecorder["drinkImageViewMax"]!
            self.nameLabel.frame.origin.x = self.positionRecorder["nameLabelMax"]!
            self.briefLabel.frame.origin.x = self.positionRecorder["briefLabelMax"]!
            self.ordererLabel.frame.origin.x = self.positionRecorder["ordererLabelMax"]!
            self.priceLabel.frame.origin.x = self.positionRecorder["priceLabelMax"]!
            self.deleteBtn.frame.origin.x = self.positionRecorder["deleteBtnMax"]!
        }
        isDeleteShow = false
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        let editCodeDic: [String : String] = ["editCode" : self.editCode, "orderer": self.orderer]
        // userInfo: [AnyHashable : Any]
        NotificationCenter.default.post(name: NSNotification.Name("deleteAction"), object: nil, userInfo: editCodeDic)
    }
}
