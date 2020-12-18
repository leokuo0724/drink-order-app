//
//  OrderListStruct.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/18.
//

import Foundation

struct PostOrder: Encodable {
    var data: OrderItem
}

struct OrderItem: Encodable {
    let group: String
    let orderer: String
    let drinkName: String
    let drinkSize: String
    let drinkTemp: String
    let drinkSugar: String
    let addOn: String
    let saySomething: String
    let totalPrice: String
    let editCode: String
    let lastUpdateTime: String
}
