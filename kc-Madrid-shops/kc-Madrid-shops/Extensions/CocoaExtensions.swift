
import UIKit


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
}
