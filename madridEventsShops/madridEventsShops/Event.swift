//
//  Event.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 26/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import Foundation


//hereda de Shop porques 100&% igual
class Event : Shop{
    
}


public class Events  {
    
    private var List : [Event]?
    
    public init() {
        self.List = []
    }
    
    func count() -> Int {
        return (List?.count)!
    }
    
    
    func get(index: Int) -> Event {
        return (List?[index])!
    }
   
    func add(event: Event) {
        List?.append(event)
    }
}
