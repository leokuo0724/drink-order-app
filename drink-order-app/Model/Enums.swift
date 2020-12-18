//
//  Enums.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import Foundation

enum OptionType {
    case temp, sugar, size, addOn, saySomething
}
enum Temp: String, CaseIterable {
    case regularIce = "正常冰 Regular Ice"
    case lessIce = "少冰 Less Ice"
    case halfIce = "微冰 Half Ice"
    case noIce = "去冰 Ice-Free"
    case roomTemp = "常溫 Room Temperature"
    case warmTemp = "溫 Warm"
    case hot = "熱 Hot"
}
enum Sugar: String, CaseIterable {
    case regularSugar = "全糖 100% Sugar"
    case lessSugar = "少糖 70% Sugar"
    case halfSugar = "半糖 50% Sugar"
    case lightSugar = "微糖 30% Sugar"
    case noSugar = "無糖 Sugar-Free"
}
enum Size: String, CaseIterable {
    case medium = "中杯 Medium"
    case large = "大杯 Large"
}
enum AddOn: String, CaseIterable {
    case whiteBubble = "白玉珍珠 White Tapioca"
    case blackBubble = "墨玉珍珠 Tapioca"
}
