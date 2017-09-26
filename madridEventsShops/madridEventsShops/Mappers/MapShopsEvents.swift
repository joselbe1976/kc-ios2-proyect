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
    
    shop.description = shopCD.descrip ?? ""
    shop.openingHours = shopCD.openingHours ?? ""
    
    //Cache logo and Image
    shop.logo_data = shopCD.logo_data
    shop.image_data = shopCD.image_data
    shop.googleMaps_data = shopCD.googlemaps_data
    
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
    shopCD.descrip = shop.description
    shopCD.openingHours = shop.openingHours
    
    //Cache Logo and Image
    shopCD.logo_data = shop.logo_data
    shopCD.image_data = shop.image_data
    shopCD.googlemaps_data = shop.googleMaps_data
    
    return shopCD
}



func mapEventCDIntoEvent(eventCD: EventCD) -> Event {
    let event = Event(name: eventCD.name ?? "Empty")
    event.address = eventCD.address ?? ""
    event.image = eventCD.image ?? ""
    event.logo = eventCD.logo ?? ""
    
    event.latitude = eventCD.latitude
    event.longitude = eventCD.logitude
    
    event.description = eventCD.descrip ?? ""
    event.openingHours = eventCD.openingHours ?? ""
    
    //Cache logo and Image
    event.logo_data = eventCD.logo_data
    event.image_data = eventCD.image_data
    event.googleMaps_data = eventCD.googlemaps_data
    
    return event
}

func mapEventIntoEventCD(context: NSManagedObjectContext, event: Event) -> EventCD {
  
    let eventCD = EventCD(context: context)
    eventCD.name = event.name
    eventCD.address = event.address
    eventCD.image = event.image
    eventCD.logo = event.logo
    
    eventCD.latitude = event.latitude ?? 0.0
    eventCD.logitude = event.longitude ?? 0.0
    eventCD.descrip = event.description
    eventCD.openingHours = event.openingHours
    
    //Cache Logo and Image
    eventCD.logo_data = event.logo_data
    eventCD.image_data = event.image_data
    eventCD.googlemaps_data = event.googleMaps_data
    
    return eventCD
}

