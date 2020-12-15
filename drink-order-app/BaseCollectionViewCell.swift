//
//  BaseCollectionViewCell.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/14.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    var drinkInfo: DrinkData?
    
    var innerView = UIView()
    var nameZHLabel = UILabel()
    var nameENLabel = UILabel()
    var descriptionLabel = UILabel()
    var imageView = UIImageView()
    var sizeLabel = UILabel()
    var priceLabel = UILabel()
    var selectBtn = UIButton()
    
    override init(frame: CGRect) {
        print("init")
        print()
        super.init(frame: frame)
        self.backgroundColor = .none
        
        innerView.frame.size = CGSize(width: self.frame.size.width-36, height: self.frame.size.height)
        innerView.frame.origin = CGPoint(x: (self.frame.size.width-innerView.frame.size.width)/2, y: 0)
        innerView.backgroundColor = .white
        innerView.layer.cornerRadius = 20
        innerView.layer.borderWidth = 2
        innerView.layer.borderColor = UIColor(named: "DeepBlueColor")?.cgColor
        innerView.clipsToBounds = true
        self.addSubview(innerView)

        nameZHLabel.frame = CGRect(x: 24, y: 24, width: innerView.frame.size.width-40, height: 32)
        nameZHLabel.textColor = UIColor(named: "DeepBlueColor")
        nameZHLabel.font = UIFont.boldSystemFont(ofSize: 28)
        innerView.addSubview(nameZHLabel)
        
        nameENLabel.frame = CGRect(x: 24, y: 56, width: innerView.frame.size.width-48, height: 18)
        nameENLabel.textColor = UIColor(named: "DeepBlueColor")
        nameENLabel.text = "Signature Black Tea"
        nameENLabel.font = UIFont.systemFont(ofSize: 15)
        nameENLabel.alpha = 0.7
        innerView.addSubview(nameENLabel)
        
        descriptionLabel.frame = CGRect(x: 24, y: 90, width: innerView.frame.size.width-76, height: 36)
        descriptionLabel.textColor = UIColor(named: "DeepBlueColor")
        descriptionLabel.text = "解炸物/燒烤肉類油膩，茶味濃郁帶果香"
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.alpha = 0.8
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 2
        innerView.addSubview(descriptionLabel)
        
        imageView.frame = CGRect(x: 24, y: 132, width: innerView.frame.size.width-48, height: innerView.frame.size.width-48)
        imageView.image = UIImage(named: "熟成紅茶")
        innerView.addSubview(imageView)
        
        sizeLabel.frame = CGRect(x: 24, y: 324, width: innerView.frame.size.width-48, height: 14)
        sizeLabel.textColor = UIColor(named: "DeepBlueColor")
        sizeLabel.text = "中杯"
        sizeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        innerView.addSubview(sizeLabel)
        
        priceLabel.frame = CGRect(x: 24, y: 340, width: innerView.frame.size.width-32, height: 33)
        priceLabel.textColor = UIColor(named: "DeepBlueColor")
        priceLabel.text = "$25"
        priceLabel.font = UIFont.boldSystemFont(ofSize: 28)
        innerView.addSubview(priceLabel)
        
        selectBtn.frame = CGRect(x: 156, y: 340, width: 68, height: 30)
        selectBtn.backgroundColor = UIColor(named: "LightYellowColor")
        selectBtn.setTitle("我要這個", for: .normal)
        selectBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        selectBtn.titleLabel?.textColor = .white
        selectBtn.layer.cornerRadius = 12
        selectBtn.addTarget(self, action: #selector(selectDrink), for: .touchUpInside)
        innerView.addSubview(selectBtn)
    }
    
    func setValues() {
        if let drinkInfo = drinkInfo {
            nameZHLabel.text = drinkInfo.name_zh.value
            nameENLabel.text = drinkInfo.name_en.value
            descriptionLabel.text = drinkInfo.description.value
            priceLabel.text = "$\(drinkInfo.priceM.value)"
        }
    }
    
    // 流水布局，因为控件会实时变化，需要在这里计算frame,如果控件大小固定，推荐直接在init方法里算
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func selectDrink() {
        if let drinkInfo = drinkInfo {
            print(drinkInfo)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
