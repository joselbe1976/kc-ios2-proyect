//
//  MOdelsShops.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 29/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import XCTest
import CoreData
@testable import madridEventsShops

class ModelsShops: XCTestCase {
    
    // Core Data
    var cds = CoreDataStack()
    var context: NSManagedObjectContext?
    
    
    override func setUp() {
        super.setUp()
        
        
        //Core Data Conext
        self.context = cds.createContainer(dbName: "madridEventsShops").viewContext
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModelBasic(){
        
        let shop = Shop(name: "tienda")
        XCTAssertNotNil(shop)
        
    }
    
    func testModelCoreData(){
        
        let shopCD = ShopCD()
        XCTAssertNotNil(shopCD)
        
    }
    
    func testModelCoreDataMapping(){
        
        let shop = Shop(name: "tienda")
        shop.descrip = "Description"
        shop.address = "Direccion"
        shop.image = "imagen1"
        shop.logo = "logo1"
        shop.latitude = 1.0
        shop.longitude = 40.0
        shop.openingHours = "Horario"
        
        //mapping
        let shopCD = mapShopIntoShopCD(context: self.context!, shop: shop)
        
        XCTAssertNotNil(shopCD)
        XCTAssertEqual(shopCD.address, "Direccion")
        
        
    }
    
    func testModelArray(){
         let shop1 = Shop(name: "tienda1")
         let shop2 = Shop(name: "tienda2")
         let shop3 = Shop(name: "tienda3")
         let shop4 = Shop(name: "tienda4")
        
         let shops = Shops()
         XCTAssertNotNil(shops)
        
        //add items
         shops.add(shop: shop1)
         shops.add(shop: shop2)
         shops.add(shop: shop3)
         shops.add(shop: shop4)
        
         XCTAssertEqual(shops.count(), 4)
        
         let aux = shops.get(index: 3)
         XCTAssertEqual(aux.name, "tienda4")
        
    }
    
}
