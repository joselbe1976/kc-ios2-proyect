//
//  ModelsMenuTest.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 29/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import XCTest

@testable import madridEventsShops

class ModelsMenuTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuItem() {
     
        let m1 = menuItem(id: "01")
        XCTAssertNotNil(m1)
    }
    
    func testMenuItemInit2() {
        
        let m1 = menuItem(id: "01", title: "title", image: "image")
        XCTAssertNotNil(m1)
    }
    
    func testMenuMain() {
        
        let menu = menuMain()
        
        XCTAssertEqual(menu.getCount(), 2)  //2 menu options
    }
    
   
    
}
