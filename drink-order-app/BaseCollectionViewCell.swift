//
//  BaseCollectionViewCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/14.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var cellIndex: Int = 0 {
        didSet {
//            textLabel.text = "\(cellIndex)"
        }
    }
    
    var innerView = UIView()
    var imageView = UIImageView()
    var nameZHLabel = UILabel()
    var nameENLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        innerView.frame.size = CGSize(width: self.frame.size.width-36, height: self.frame.size.height)
        innerView.frame.origin = CGPoint(x: (self.frame.size.width-innerView.frame.size.width)/2, y: 0)
        innerView.backgroundColor = .white
        innerView.layer.cornerRadius = 20
        innerView.layer.borderWidth = 2
        innerView.layer.borderColor = UIColor(named: "DeepBlueColor")?.cgColor
        innerView.clipsToBounds = true
        self.addSubview(innerView)

        nameZHLabel.frame = CGRect(x: 16, y: 16, width: innerView.frame.size.width-16, height: 17)
        nameZHLabel.textColor = UIColor(named: "DeepBlueColor")
        nameZHLabel.text = "熟成紅茶熟成紅茶"
        nameZHLabel.font = UIFont.boldSystemFont(ofSize: 17)
        innerView.addSubview(nameZHLabel)
        
        nameENLabel.frame = CGRect(x: 16, y: 36, width: innerView.frame.size.width-36, height: 12)
        nameENLabel.textColor = UIColor(named: "DeepBlueColor")
        nameENLabel.text = "Signature Black Tea"
        nameENLabel.font = UIFont.systemFont(ofSize: 10)
        innerView.addSubview(nameENLabel)
    }
    
    // 流水布局，因为控件会实时变化，需要在这里计算frame,如果控件大小固定，推荐直接在init方法里算
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
