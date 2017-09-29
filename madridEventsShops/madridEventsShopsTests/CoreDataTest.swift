//
//  CoreDataTest.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 29/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import XCTest
import CoreData
@testable import madridEventsShops


class CoreDataTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testCoreDataStack(){
        let cds = CoreDataStack()
        XCTAssertNotNil(cds)
    }
    
    func testCoreDataContext(){
        let cds = CoreDataStack()
        var context: NSManagedObjectContext?
        context = cds.createContainer(dbName: "madridEventsShops").viewContext
        XCTAssertNotNil(context)
        
    }
    
    
}
