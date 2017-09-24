//
//  SaveAllShopsinteractor.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 15/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import CoreData

protocol SaveAllShopsInteractor {
    // execute: saves all shops. Return on the main thread
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void, onError: errorClosure)
    func execute(shops: Shops, context: NSManagedObjectContext, onSuccess: @escaping (Shops) -> Void)
}
