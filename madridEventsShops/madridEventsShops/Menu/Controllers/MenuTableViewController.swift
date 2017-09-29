

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
        
        
        //Core Data Conext
        self.context = cds.createContainer(dbName: "madridEventsShops").viewContext
        
        //create Menu Options
        self.menu  = menuMain()

        
        //registramos la celda
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")

        
        //SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando Datos"))
        
        //title
        
        self.title =  NSLocalizedString("MENU_MAIN_TITLE", comment: "Menu")

        
        //internet connection
        if isConnectedToNetwork() == false{
            SVProgressHUD.showError(withStatus: NSLocalizedString("INTERNET_NO", comment: "No internet connection"))
            
        }
        else
        {
            //control de descarga
            self.DownloadManager()
        }
        
        
        
    }

    //save CoreData
    override func viewWillDisappear(_ animated: Bool) {
        self.cds.saveContext(context: context!)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        //no downloaded No secctions
        if self.IsDownloaded() == false {
            return 0
        }
        
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
        
        //setup de background
        if menuItem?.id == "01" {
            cell.background.image = UIImage(named: "shopsMadrid.jpg")
        }else{
             cell.background.image = UIImage(named: "eventsMadrid.jpg")
        }
        
        return cell
    }
    
    //cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
   
    
    
    
    
    // MARK : Download Data section --------------------------------------
    
    // control if is downloaded
    func IsDownloaded() -> Bool{
        
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: "once") {
            return true
        }
        else{
            return false
        }

    }
    
    
    
    // manager of download all data Show and Events
    
    
    func DownloadManager(){
        
        if isConnectedToNetwork() == true{
            
            //OK internet Connection. If not downloades
            
            if self.IsDownloaded() == false{
                
                // Shops And Events
                ExecuteOnceInteractorImpl().execute {
                    initializeData(closure: { 
                        self.initializeDataEvents()
                        
                    })
                }
                
            }
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Sin conexión de internet")
        }

    }
    
    
    
    func initializeData(closure: @escaping () -> Void) {
        let downloadShopsInteractor: DownloadAllShopsInteractor = DownloadAllShopsInteractorNSURLSessionImpl()
        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))
        
        downloadShopsInteractor.execute { (shops: Shops) in
            // todo OK
            let cacheInteractor = SaveAllInteractorImpl()
            cacheInteractor.execute(shops: shops, context: self.context!, onSuccess: { (shops: Shops) in
                SetExecutedOnceInteractorImpl().execute()
          
                
                //cache all images
                self.CacheAllDataShops()
                
                
                //execute the clouser
                closure()
                
                
                
                
            })
        }
        
        
        
        
    }
    
    //Cachhe All Images Shops
    func CacheAllDataShops(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let shopsCd : [ShopCD] = obj.getAllShops(context: self.context!)
        
        //all items
        for shopCD in shopsCd {
            
            let iv = UIImageView()
            
            //logos
            shopCD.logo?.loadImageAndCacheShop(into: iv, context: self.context!, shop: mapShopCDIntoShop(shopCD: shopCD))
            
            //images
            shopCD.image?.loadImageAndCacheShop(into: iv, context: self.context!, shop: mapShopCDIntoShop(shopCD: shopCD), typeImage: "image")
            
            
            //location GoogleMaps Image
            let googleURL : String = "https://maps.googleapis.com/maps/api/staticmap?center=XXX,YYY&zoom=17&size=320x220&scale=2&markers=%7Ccolor:0x9C7B14%7CXXX,YYY"
            
            let urlStringFinal = googleURL.replacingOccurrences(of: "YYY", with: String(describing: shopCD.logitude)).replacingOccurrences(of: "XXX", with: String(describing: shopCD.latitude)).replacingOccurrences(of: ",0.0", with: "")
            
            urlStringFinal.loadImageAndCacheShop(into: iv, context: self.context!, shop: mapShopCDIntoShop(shopCD: shopCD), typeImage: "google")
            
        }
        
    }
    
    
    
    func initializeDataEvents() {
        let downloadInteractor : DownloadAllEventsInteractor = DownloadAllEventsInteractorNSURLSessionImpl()
      
        
        downloadInteractor.execute { (event: Events) in
            // todo OK
            
            
            let cacheInteractor = SaveAllInteractorImpl()
            
            cacheInteractor.execute(events: event, context: self.context!, onSuccess: { (events: Events) in
                SetExecutedSecondInteractorImpl().execute()
                

                //cache all images
                self.CacheAllDataEvents()
                
                //recargamos el menu porque esta ya cargado
                self.tableView.reloadData()
                
                //fin
                SVProgressHUD.dismiss()
                
                
            })
        }

    }
    
    
    //Cachhe All Images
    func CacheAllDataEvents(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let eventsCd : [EventCD] = obj.getAllEvents(context: self.context!)
        
        //all items
        for eventCd in eventsCd {
            
            let iv = UIImageView()
            
            //logos
            eventCd.logo?.loadImageAndCacheEvent(into: iv, context: self.context!, event: mapEventCDIntoEvent(eventCD: eventCd))
            
            //images
            eventCd.image?.loadImageAndCacheEvent(into: iv, context: self.context!, event: mapEventCDIntoEvent(eventCD: eventCd), typeImage: "image")
            
            //location GoogleMaps Image
            let googleURL : String = "https://maps.googleapis.com/maps/api/staticmap?center=XXX,YYY&zoom=17&size=320x220&scale=2&markers=%7Ccolor:0x9C7B14%7CXXX,YYY"
            
            let urlStringFinal = googleURL.replacingOccurrences(of: "YYY", with: String(describing: eventCd.logitude)).replacingOccurrences(of: "XXX", with: String(describing: eventCd.latitude)).replacingOccurrences(of: ",0.0", with: "")
            
            urlStringFinal.loadImageAndCacheEvent(into: iv, context: self.context!, event: mapEventCDIntoEvent(eventCD: eventCd), typeImage: "google")
            
        }
        
    }

    
    
}
