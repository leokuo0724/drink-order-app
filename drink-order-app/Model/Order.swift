//
//  Order.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/17.
//

import Foundation

class Order {
    var drinkName: String?
    var drinkTemp: Temp?
    var drinkSugar: Sugar?
    var drinkSize: Size?
    var addOn: Array<AddOn> = []
    var saySomething: String?
    var totalPrice: Int?
    
    init(drinkName: String?,
         drinkTemp: Temp?,
         drinkSugar: Sugar?,
         drinkSize: Size?,
         saySomething: String?,
         totalPrice: Int?) {
        self.drinkName = drinkName
        self.drinkTemp = drinkTemp
        self.drinkSugar = drinkSugar
        self.drinkSize = drinkSize
        self.saySomething = saySomething
        self.totalPrice = totalPrice
    }
    
    func reset() {
        drinkName = nil
        drinkTemp = nil
        drinkSugar = nil
        drinkSize = nil
        addOn = []
        saySomething = nil
        totalPrice = nil
    }
}