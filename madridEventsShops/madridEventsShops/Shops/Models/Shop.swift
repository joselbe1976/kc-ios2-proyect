//
//  Shop.swift
//  MadridShops
//
//  Created by Manuel Colmenero Navarro on 7/9/17.
//  Copyright © 2017 Manuel Colmenero Navarro. All rights reserved.
//

import Foundation

public class Shop : NSObject {
    var name         : String
    var descrip  : String   = ""
    var latitude     : Float?   = nil
    var longitude    : Float?   = nil
    var image        : String   = ""
    var logo         : String   = ""
    var openingHours : String   = ""
    var address      : String   = ""
    
    //Cache Logo and Image
    var logo_data : NSData?
    var image_data : NSData?
    var googleMaps_data : NSData?
    
    public init(name: String) {
        self.name = name
    }
    
    
}
