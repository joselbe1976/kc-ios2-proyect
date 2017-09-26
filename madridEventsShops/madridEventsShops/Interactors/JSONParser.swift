//
//  JSONParser.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 12/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import Foundation


func parseShops(data: Data) -> Shops {
    let shops = Shops()
    let langStr = Locale.current.languageCode
    
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
        let result = jsonObject["result"] as! [Dictionary<String, Any>]
        
        for shopJson in result {
            let shop = Shop(name: shopJson["name"]! as! String)
            shop.address = shopJson["address"]! as! String
            shop.logo = shopJson["logo_img"] as! String
            shop.image = shopJson["img"] as! String
            
            if (langStr == "es"){
                shop.description = shopJson["description_es"] as! String
                shop.openingHours = shopJson["opening_hours_es"] as! String
            }
            else{
                shop.description = shopJson["description_en"] as! String
                shop.openingHours = shopJson["opening_hours_en"] as! String
            }
            shop.latitude = (shopJson["gps_lat"] as? String)!.floatValue()
            shop.longitude = (shopJson["gps_lon"] as? String)!.floatValue()
            
            
            
            
            shops.add(shop: shop)
        }
    } catch {
        print("Error parsing JSON")
    }
    return shops
}




func parseEvents(data: Data) -> Events {
    let events = Events()
    let langStr = Locale.current.languageCode
    
    do {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Dictionary<String, Any>
        let result = jsonObject["result"] as! [Dictionary<String, Any>]
        
        for shopJson in result {
            let event = Event(name: shopJson["name"]! as! String)
            event.address = shopJson["address"]! as! String
            event.logo = shopJson["logo_img"] as! String
            event.image = shopJson["img"] as! String
            
            if (langStr == "es"){
                event.description = shopJson["description_es"] as! String
                event.openingHours = shopJson["opening_hours_es"] as! String
            }
            else{
                event.description = shopJson["description_en"] as! String
                event.openingHours = shopJson["opening_hours_en"] as! String
            }
            event.latitude = (shopJson["gps_lat"] as? String)!.floatValue()
            event.longitude = (shopJson["gps_lon"] as? String)!.floatValue()
            
            
            
            
            events.add(event: event)
        }
    } catch {
        print("Error parsing JSON")
    }
    return events
}
