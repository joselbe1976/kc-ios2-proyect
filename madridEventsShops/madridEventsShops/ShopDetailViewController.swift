//
//  ShopDetailViewController.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 25/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit
import CoreData

class ShopDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var textDescription: UITextView!
    
    var context: NSManagedObjectContext?
    var shop: Shop?
    
    init(shop: Shop, context: NSManagedObjectContext) {
            super.init(nibName: nil, bundle: nil)
        
            self.context = context
            self.shop = shop
        
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //title
        self.title = self.shop?.name
        
        //write data
        self.refresh()

    }
    
    func refresh(){
        
        self.textDescription.text = shop?.description
        
        //image and Cache Control
        if let imagen = shop?.googleMaps_data{
            
            //esta cacheado, lo meto en la imagen
            image.image = UIImage(data: imagen as Data)
        }
        /*else{
            //No esta, cargamos y cacheado
            
            shop?.image.loadImageAndCacheShop(into: image, context: self.context!, shop: self.shop!, typeImage: "image") //image cache
        }
 */
        
    }

   
}
