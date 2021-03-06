
import UIKit
import CoreData

extension UIViewController{
    
    func wrappedInNavigation() -> UINavigationController{
        let nav = UINavigationController(rootViewController: self)
        return nav
    }
}




// Carga de imagenes en segundo plano
extension String {
    func loadImage (into imageView: UIImageView) {
        let queue = OperationQueue()
        queue.addOperation {
            if let url = URL(string: self),
                let data = NSData (contentsOf: url),
                let image = UIImage (data: data as Data) {
                
                // Se devuelve el control a la linea principal
                OperationQueue.main.addOperation {
                    imageView.image = image
                    
                }
            }
        }
    }
    
    func loadImageAndCacheShop (into imageView: UIImageView, context : NSManagedObjectContext, shop : Shop, typeImage : String = "logo") {
        //Elimino el trabajo en segundo plano por espeficicacion del proyecto de keepcoding, que quieren que este todo cargado ... y como el usuario esta esperando no tiene
        // sentido lanzarlo en llamadas asincronas.
        
      //  let queue = OperationQueue()
      //  queue.addOperation {
            if let url = URL(string: self),
                let data = NSData (contentsOf: url),
                let logo = UIImage (data: data as Data) {
                
                // Main Thread control
              //  OperationQueue.main.addOperation {
                    imageView.image = logo
                    
                    
                    //Cache With CoreData. Add The cache. Was verificated when componen the cell

                    
                    let predicate = NSPredicate(format: "name = %@", shop.name)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopCD")
                    fetchRequest.predicate = predicate
 
                    do {
                        let results = try context.fetch(fetchRequest)
                        let shopCD = (results as! [ShopCD])[0]
                        
                        if typeImage == "logo"{
                            print("es cache de Logo")
                            shopCD.logo_data = data
                        }
                        else if typeImage == "google" {
                            print("es cache de Google")
                            shopCD.googlemaps_data = data
                            
                        
                        }
                        else{
                            print("es cache de imagen")
                            shopCD.image_data = data
                        }
                        try context.save()
                        
                        
                    } catch  {
                        
                    }

                    
               // }
               // }
        }
    }
    
   
    
    
    func loadImageAndCacheEvent (into imageView: UIImageView, context : NSManagedObjectContext, event : Event, typeImage : String = "logo") {
        
        
    //Elimino el trabajo en segundo plano por espeficicacion del proyecto de keepcoding, que quieren que este todo cargado ... y como el usuario esta esperando no tiene
    // sentido lanzarlo en llamadas asincronas.
        
        
    //    let queue = OperationQueue()
    //    queue.addOperation {
            if let url = URL(string: self),
                let data = NSData (contentsOf: url),
                let logo = UIImage (data: data as Data) {
                
                // Main Thread control
              //  OperationQueue.main.addOperation {
                    imageView.image = logo
                    
                    
                    //Cache With CoreData. Add The cache. Was verificated when componen the cell
                    
                    
                    let predicate = NSPredicate(format: "name = %@", event.name)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventCD")
                    fetchRequest.predicate = predicate
                    
                    do {
                        let results = try context.fetch(fetchRequest)
                        let eventCD = (results as! [EventCD])[0]
                        
                        if typeImage == "logo"{
                            print("es cache de Logo")
                            eventCD.logo_data = data
                        }
                        else if typeImage == "google" {
                            print("es cache de Google")
                            eventCD.googlemaps_data = data
                            
                            
                        }
                        else{
                            print("es cache de imagen")
                            eventCD.image_data = data
                        }
                        try context.save()
                        
                        
                    } catch  {
                        
                    }
                    
                    
             //   }
            }
       // }
    }

    
}


extension UIImage{
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return self
    }

}




//to convert String To Float
extension String {
    func floatValue() -> Float? {
        if let floatval = Float(self) {
            return floatval
        }
        return nil
    }
}




