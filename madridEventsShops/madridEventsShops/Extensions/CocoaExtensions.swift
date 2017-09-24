
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
    
    func loadImageAndCache (into imageView: UIImageView, context : NSManagedObjectContext, shop : Shop) {
       
        let queue = OperationQueue()
        queue.addOperation {
            if let url = URL(string: self),
                let data = NSData (contentsOf: url),
                let image = UIImage (data: data as Data) {
                
                // Se devuelve el control a la linea principal
                OperationQueue.main.addOperation {
                    imageView.image = image
                    
                    
                    //Cache With CoreData. Add The cache. Was verificated when componen the cell
                    
                   let shopCD = mapShopIntoShopCD(context: context, shop: shop)
                   shopCD.logo_data = data
                    
                    
                 /*   var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopCD")
                    fetchRequest.predicate = NSPredicate(format: "name = %@", shop.name)
                    
                    
                   
                    
                    if let fetchResults = context.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                        if fetchResults.count != 0{
                            
                            var managedObject = fetchResults[0]
                            managedObject.setValue(data, forKey: "logo_data")
                            
                            do {
                                try context.save()
                            } catch {
                                let nserror = error as NSError
                                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                            }

                        }
                    }
 */
                    
                    
                    
                    
                }
            }
        }
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
