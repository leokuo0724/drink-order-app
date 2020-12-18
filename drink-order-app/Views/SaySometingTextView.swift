//
//  SaySometingTextView.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import UIKit

class SaySometingTextView: UITextView, UITextViewDelegate {

    override func draw(_ rect: CGRect) {
        self.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.text = "想說點什麼呢..."
        self.textColor = .white
        self.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        order.saySomething = self.text
    }

}
