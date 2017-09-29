//
//  EventDetailViewController.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 28/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit
import CoreData

class EventDetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var text: UITextView!
    
    var context: NSManagedObjectContext?
    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.event?.name
        
        self.refresh()
    }

    
    init(event: Event, context: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        
        self.context = context
        self.event = event
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //generic function
    func refresh() -> Void{
        
        self.text.text = event?.descrip
        self.label.text = event?.address
        
        //image and Cache Control
        if let img = event?.googleMaps_data{
            
            //esta cacheado, lo meto en la imagen
            image.image = UIImage(data: img as Data) //?.resizeImage(targetSize: CGSize(width: 320, height: 320))
        }
        else{
            //error de excess of use googleMap. use image default
            image.image = #imageLiteral(resourceName: "googleDefault.png").resizeImage(targetSize: CGSize(width: 320, height: 320))
        }


    }
   
    
}
