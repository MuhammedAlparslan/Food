//
//  Struct.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import Foundation

struct Account: Decodable, Encodable  {
    let fullname        : String
    let emailadress     : String
    let password        : String
    let birthdate       : String
}

struct RestaurantName: Decodable, Encodable {
    let name        : String
    let image       : String
    let restorans   : [ProductList]
}

struct ProductList: Decodable, Encodable {
    let name  :  String
    let image : String
    let price : String
}

struct Order: Decodable, Encodable {
    let name    : String
    let price   : String
    let pieces  : String
    let image   : String
}

struct Card: Decodable, Encodable {
    let name        : String
    let cardNumber  : String
    let cardDate    : String
    let cardCVC     : String
}
