//
//  ShopCell.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 24/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit
import CoreData

class ShopCell: UITableViewCell {
    
    var shop: Shop?
    
    

    @IBOutlet weak var image2: UIImageView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func refresh(shop: Shop, context: NSManagedObjectContext) {
        self.shop = shop
        
        self.label.text = shop.name
        self.subTitle.text = shop.openingHours
        
        //Miramos si estacacheado el logo.
        if let logo = shop.logo_data{
            
            //esta cacheado, lo meto en la imagen
            image2.image = UIImage(data: logo as Data)
            
            image2.clipsToBounds = true
            
            //redimensiono la imagen
            image2.image = image2.image?.resizeImage(targetSize: CGSize(width: 90  , height: 90))
        }
        
        if let background = shop.image_data{
            
            //esta cacheado, lo meto en la imagen
            backgroundImage.image = UIImage(data: background as Data)
        }
        
        
        
        
        
        
   
    }
    

    
}
