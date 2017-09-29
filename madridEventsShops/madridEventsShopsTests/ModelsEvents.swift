//
//  ModelsEvents.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 29/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import XCTest
import CoreData
@testable import madridEventsShops

class ModelsEvents: XCTestCase {
    
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
        
        let event = Event(name: "Evento")
        XCTAssertNotNil(event)
        
    }
    
    func testModelCoreData(){
        
        let eventCD = EventCD()
        XCTAssertNotNil(eventCD)
        
    }
    
    func testModelCoreDataMapping(){
        
        let event = Event(name: "Evento")
        event.descrip = "Description"
        event.address = "Direccion"
        event.image = "imagen1"
        event.logo = "logo1"
        event.latitude = 1.0
        event.longitude = 40.0
        event.openingHours = "Horario"
        
        //mapping
        let eventCD = mapEventIntoEventCD(context: self.context!, event: event)
        
        XCTAssertNotNil(eventCD)
        XCTAssertEqual(eventCD.address, "Direccion")
        
        
    }
    
    func testModelArray(){
        let event1 = Event(name: "tienda1")
        let event2 = Event(name: "tienda2")
        let event3 = Event(name: "tienda3")
        let event4 = Event(name: "tienda4")
        
        let events = Events()
        XCTAssertNotNil(events)
        
        //add items
        events.add(event: event1)
        events.add(event: event2)
        events.add(event: event3)
        events.add(event: event4)
        
        XCTAssertEqual(events.count(), 4)
        
        let aux = events.get(index: 2)
        XCTAssertEqual(aux.name, "tienda3")
        
    }

    
}
