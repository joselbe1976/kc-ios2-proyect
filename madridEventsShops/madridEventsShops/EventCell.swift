//
//  EventCell.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 26/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit
import CoreData

class EventCell: UITableViewCell {

    var event: Event?
    
    
    
    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func refresh(event: Event, context: NSManagedObjectContext) {
        self.event = event
        
        self.label.text = event.name
        
        //Miramos si estacacheado el logo.
        if let logo = event.logo_data{
            
            //esta cacheado, lo meto en la imagen
            image2.image = UIImage(data: logo as Data)
        }
        else{
            //No esta, cargamos y cacheado
            
            self.event?.logo.loadImageAndCacheEvent(into: image2, context: context, event: event)
        }
        
        image2.clipsToBounds = true
        
        //redimensiono la imagen
        image2.image = image2.image?.resizeImage(targetSize: CGSize(width: 90  , height: 90))
        
    }

    
}
