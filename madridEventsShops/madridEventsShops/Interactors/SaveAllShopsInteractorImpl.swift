//
//  SaveAllShopsInteractorImpl.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 15/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import CoreData

class SaveAllInteractorImpl: SaveAllInteractor {
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void, onError: errorClosure) {
        
        for i in 0 ..< shops.count() {
            let shop = shops.get(index: i)
            
            let _ = mapShopIntoShopCD(context: context, shop: shop)
        }
        
        do {
            try context.save()
            onSuccess(shops)
        } catch {
            // onError(nil)
        }
        
    }
    
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void) {
        execute(shops: shops, context: context, onSuccess: onSuccess, onError: nil)
    }
    
    
    
    func execute(events: Events, context: NSManagedObjectContext, onSuccess: @escaping (Events) -> Void, onError: errorClosure) {
        
        for i in 0 ..< events.count() {
            let event = events.get(index: i)
            
            let _ = mapEventIntoEventCD(context: context, event: event)
        }
        
        do {
            try context.save()
            onSuccess(events)
        } catch {
            // onError(nil)
        }
        
    }
    
    func execute(events: Events, context: NSManagedObjectContext, onSuccess: @escaping (Events) -> Void) {
        execute(events: events, context: context, onSuccess: onSuccess, onError: nil)
    }
    
    
}
