

import CoreData


public class CoreDataStack {

    // MARK: - Core Data stack

    public func createContext(dbName : String) -> NSPersistentContainer  {
         
            
            let container = NSPersistentContainer(name: dbName) //nombre del fichero BBDD CoreData
        
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                print("💾  \(storeDescription.description)")
                
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
     }

    // MARK: - Core Data Saving support

    public func saveContext (context: NSManagedObjectContext) {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
     }


}
