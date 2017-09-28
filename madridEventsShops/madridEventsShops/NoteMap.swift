//
//  NoteMap.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 26/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import Foundation
import MapKit


//anotation class
class Note: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var name : String?
    
    var entity : Shop?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, name: String, entity : Shop) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.name = name
        self.entity = entity
        
    }
    

}
