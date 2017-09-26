//
//  SaveAllShopsinteractor.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 15/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import CoreData

protocol SaveAllInteractor {
    // execute: saves all shops. Return on the main thread
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void, onError: errorClosure)
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void)
    
    // execute: saves all shops. Return on the main thread
    func execute(events: Events, context: NSManagedObjectContext, onSuccess: @escaping (Events) -> Void, onError: errorClosure)
    func execute(events: Events, context: NSManagedObjectContext, onSuccess: @escaping (Events) -> Void)
}



