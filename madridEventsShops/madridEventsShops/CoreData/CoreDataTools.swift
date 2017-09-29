

import Foundation
import CoreData


public class  coreDataTools{


    
    //Get All ShopsCD
    public func getAllShops(context: NSManagedObjectContext) -> [ShopCD] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopCD")
        
        var shopsCD : [ShopCD]!
        
        do {
            let results = try context.fetch(fetchRequest)
            shopsCD = results as! [ShopCD]
           
        } catch  {
          
        }
        
        return shopsCD
    }
  
    public func getShopsFilterName(context: NSManagedObjectContext, name : String) -> ShopCD {
        
        var shopCD : ShopCD?
        let predicate = NSPredicate(format: "name = %@", name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShopCD")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            shopCD = (results as! [ShopCD])[0]
            
        } catch  {
            
        }
        
         return shopCD!
    }


    
    //Get All EventsCD
    public func getAllEvents(context: NSManagedObjectContext) -> [EventCD] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventCD")
        
        var eventCD : [EventCD]!
        
        do {
            let results = try context.fetch(fetchRequest)
            eventCD = results as! [EventCD]
            
        } catch  {
            
        }
        
        return eventCD
    }
    
    public func getEventFilterName(context: NSManagedObjectContext, name : String) -> EventCD {
        
        var eventCD : EventCD?
        let predicate = NSPredicate(format: "name = %@", name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventCD")
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            eventCD = (results as! [EventCD])[0]
            
        } catch  {
            
        }
        
        return eventCD!
    }

    

}
