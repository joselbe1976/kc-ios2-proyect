//
//  MapShops.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 18/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import CoreData

func mapShopCDIntoShop(shopCD: ShopCD) -> Shop {
    let shop = Shop(name: shopCD.name ?? "Empty")
    shop.address = shopCD.address ?? ""
    shop.image = shopCD.image ?? ""
    shop.logo = shopCD.logo ?? ""
    
    shop.latitude = shopCD.latitude
    shop.longitude = shopCD.logitude
    
    shop.description = shopCD.description_en ?? ""
    shop.openingHours = shopCD.openingHours ?? ""
    
    //Cache logo
    shop.logo_data = shopCD.logo_data
    
    return shop
}

func mapShopIntoShopCD(context: NSManagedObjectContext, shop: Shop) -> ShopCD {
    // mapping shop into ShopCD
    let shopCD = ShopCD(context: context)
    shopCD.name = shop.name
    shopCD.address = shop.address
    shopCD.image = shop.image
    shopCD.logo = shop.logo
    
    shopCD.latitude = shop.latitude ?? 0.0
    shopCD.logitude = shop.longitude ?? 0.0
    shopCD.description_en = shop.description
    shopCD.openingHours = shop.openingHours
    
    //Cache Logo
    shopCD.logo_data = shop.logo_data
    
    return shopCD
}

