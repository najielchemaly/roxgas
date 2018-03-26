//
//  DatabaseObjects.swift
//  rox
//
//  Created by MR.CHEMALY on 10/18/17.
//  Copyright © 2017 intouch. All rights reserved.
//

import Foundation
import GoogleMaps

class DatabaseObjects {
    
    static var FIREBASE_TOKEN: String!
    static var USER_LOCATION: CLLocation!
    static var IS_IN_REVIEW: Bool!
    
    static var user: User = User()
    static var products: [Product] = [Product]()
    static var provinces: [Province] = [Province]()
    static var notifications: [Notification] = [Notification]()
    static var pointsOfSale: [Pos] = [Pos]()
    static var histories: [History] = [History]()
    static var refills: [Refill] = [Refill]()
    static var deliveryCharges: [DeliveryCharge] = [DeliveryCharge]()
    
}
