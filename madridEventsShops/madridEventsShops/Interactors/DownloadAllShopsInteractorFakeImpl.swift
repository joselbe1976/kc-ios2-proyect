//
//  DownloadAllShopsInteractorFakeImpl.swift
//  MadridShops
//
//  Created by Diego Freniche Brito on 07/09/2017.
//  Copyright © 2017 KC. All rights reserved.
//

import Foundation

class DownloadAllShopsInteractorFakeImpl: DownloadAllShopsInteractor {
    func execute(onSuccess: @escaping (Shops) -> Void) {
        execute(onSuccess: onSuccess, onError: nil)
    }
    
    func execute(onSuccess: @escaping (Shops) -> Void, onError: errorClosure = nil) {
        let shops = Shops()
        
        for i in 0...10 {
            let shop = Shop(name: "Shop number \( i )")
            shop.address = "Address \( 1 )"
            
            shops.add(shop: shop)
        }
        
        OperationQueue.main.addOperation {
           onSuccess(shops)
        }
    }
    
    
}
