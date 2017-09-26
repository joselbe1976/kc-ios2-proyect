

import UIKit
import SVProgressHUD
import CoreData


class MenuTableViewController: UITableViewController {
    
    var menu : menuMain?
    
    // Core Data
    var cds = CoreDataStack()
    var context: NSManagedObjectContext?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //internet connection
        if isConnectedToNetwork() == false{
            SVProgressHUD.showError(withStatus: NSLocalizedString("INTERNET_NO", comment: "No internet connection"))
           
        }
        
        
        //Core Data Conext
        self.context = cds.createContainer(dbName: "madridEventsShops").viewContext
        
        //create Menu Options
        self.menu  = menuMain()

        
        //registramos la celda
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")

        
        //SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando Datos"))
        
        //title
        
        self.title =  NSLocalizedString("MENU_MAIN_TITLE", comment: "Menu")
        
    }

    //save CoreData
    override func viewWillDisappear(_ animated: Bool) {
        self.cds.saveContext(context: context!)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.menu?.getCount())!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        //extract de model of menu
        
        let menuItem = self.menu?.getItem(atIndex: indexPath.row)
        
        //setup the cell
        cell.LabelText.text = menuItem?.title
        cell.imageCell.image = UIImage(named: (menuItem?.image)!)
        
        return cell
    }
    
    //cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // selected Menu
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        
        
        
        if (indexPath.row == 0){
            
            // Shops
            
            let ShopsVC = ShopsViewController()
            ShopsVC.context = self.context
            self.navigationController?.pushViewController(ShopsVC, animated: true)
            
            
        }
        else{
            //events
        
            let EventSVC = EventsViewController()
            EventSVC.context = self.context
            self.navigationController?.pushViewController(EventSVC, animated: true)
        }
        
        
        
    }
   

    
    
}
