//
//  DrinkData.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/15.
//

import Foundation

struct SheetStruct: Codable {
    let feed: Feed
}

struct Feed: Codable {
    let entry: Array<DrinkData>
}


struct DrinkData: Codable {
    let name_zh: StringType
    let name_en: StringType
    let description: StringType
    let imageUrl: StringType
    let priceM: StringType
    let maxCalorieM: StringType
    let priceL: StringType
    let maxCalorieL: StringType
    let isCanAddWhiteBubble: StringType
    let isCanAddBlackBubble: StringType
    let isPopular: StringType
    
    enum CodingKeys: String, CodingKey {
        case name_zh = "gsx$namezh"
        case name_en = "gsx$nameen"
        case description = "gsx$description"
        case imageUrl = "gsx$imageurl"
        case priceM = "gsx$pricem"
        case maxCalorieM = "gsx$maxcaloriem"
        case priceL = "gsx$pricel"
        case maxCalorieL = "gsx$maxcaloriel"
        case isCanAddWhiteBubble = "gsx$iscanaddwhitebubble"
        case isCanAddBlackBubble = "gsx$iscanaddblackbubble"
        case isPopular = "gsx$ispopular"
    }
}

struct StringType: Codable {
    let value: String
    enum CodingKeys: String, CodingKey {
        case value = "$t"
    }
}
//struct URLType: Codable {
//    let value: URL?
//    enum CodingKeys: String, CodingKey {
//        case value = "$t"
//    }
//}
//struct IntType: Codable {
//    let value: Int
//    enum CodingKeys: String, CodingKey {
//        case value = "$t"
//    }
//}
//struct BoolType: Codable {
//    let value: Bool
//    enum CodingKeys: String, CodingKey {
//        case value = "$t"
//    }
//}
