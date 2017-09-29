//
//  ModelsNoteMaps.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 29/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import XCTest
import MapKit

@testable import madridEventsShops

class ModelsNoteMaps: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBasic() {
        
        let coordinate = CLLocationCoordinate2D()
        let shop = Shop(name: "CorteIngles")
        
        let note = Note(coordinate: coordinate, title: "titulo", subtitle : "subtitle", name: "name", entity : shop)
        
        XCTAssertNotNil(note)
        
    }
    
    
    
}
