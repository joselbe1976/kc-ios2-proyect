//
//  ShopsViewController.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 24/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit
import SVProgressHUD


class Note: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var name : String?

    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, name: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.name = name
   

    }
}



class ShopsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // CoreData Context
    var context: NSManagedObjectContext!
    
    //outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var shopsCollectionView: UITableView!
    
    //Location
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))

        
        // REGISTER SHOPCELL

        //registramos la celda
        shopsCollectionView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: "ShopCell")
        

        
        //User Autorization
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
        
        
        //configure the MapKit
        let madridLocation = CLLocation(latitude: 40.416775, longitude: -3.703790)
        self.map.setCenter(madridLocation.coordinate, animated: true)
        
        let region = MKCoordinateRegion(center: madridLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        let reg = self.map.regionThatFits(region)
        self.map.setRegion(reg, animated: true)
        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))
        
        //Load Data from Json If is not store
        ExecuteOnceInteractorImpl().execute {
            
            initializeData()
            
        }
        
        self.shopsCollectionView.delegate = self
        self.shopsCollectionView.dataSource = self

        self.FillMapPoints()
      //  self.CacheAllData() //quitar
        
    }
    

    
    func initializeData() {
        let downloadShopsInteractor: DownloadAllShopsInteractor = DownloadAllShopsInteractorNSURLSessionImpl()
        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))
        
        downloadShopsInteractor.execute { (shops: Shops) in
            // todo OK
            
            
            
            let cacheInteractor = SaveAllShopsInteractorImpl()
            cacheInteractor.execute(shops: shops, context: self.context, onSuccess: { (shops: Shops) in
                SetExecutedOnceInteractorImpl().execute()
                
                self._fetchedResultsController = nil
                self.shopsCollectionView.delegate = self
                self.shopsCollectionView.dataSource = self
                self.shopsCollectionView.reloadData()
               
                //cache all images
                self.CacheAllData()

                
            })
        }
    }
   
    
    
    // MARK: - Fetched results controller
    var _fetchedResultsController: NSFetchedResultsController<ShopCD>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<ShopCD> {
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<ShopCD> = ShopCD.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        // fetchRequest == SELECT * FROM EVENT ORDER BY TIMESTAMP DESC
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: "ShopsCacheFile")
        // aFetchedResultsController.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.map.setCenter(location.coordinate, animated: true)
    }
    
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        print("*** MAP STARTING")

    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("** MAP FINISH LOADING")
           }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("** START LOCATING USER")
        
 
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("** STOP LOCATING USER")
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view == mapView.userLocation {
            return
        }
        
        print("Touch")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("deselect")
    }

    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
     //   guard let annotation = annotation as? ShopAnnotation else { return nil }
        
        let identifier = "marker"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            
            
            //sacamos el logo de CoreData
            
            let tools = coreDataTools()
            let shopCD = tools.getShopsFilterName(context: self.context, name: annotation.title as! String)
            
            
            if let logoData = shopCD.logo_data{
                let mapsButtom = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
                mapsButtom.setBackgroundImage(UIImage(data: logoData as Data), for: UIControlState())
                view.rightCalloutAccessoryView = mapsButtom
            } else {
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        return view
    }
    
    
    // Fill All point in the map from CoreData
    
    func FillMapPoints(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let shopsCd : [ShopCD] = obj.getAllShops(context: self.context)
        
        //all items
        for shopCD in shopsCd {
            let location = CLLocation(latitude: CLLocationDegrees(shopCD.latitude), longitude: CLLocationDegrees(shopCD.logitude))
            
            let n=Note(coordinate: location.coordinate, title: shopCD.name!, subtitle: shopCD.address!, name: shopCD.name!)
            self.map.addAnnotation(n)

        }
        //piut the delegate
        self.map.delegate = self
        
        if shopsCd.count > 0 {
            SVProgressHUD.dismiss()
        }
      }
  
    //Cachhe All Images
    func CacheAllData(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let shopsCd : [ShopCD] = obj.getAllShops(context: self.context)
        
        //all items
        for shopCD in shopsCd {
           
            let iv = UIImageView()
            
            //logos
            shopCD.logo?.loadImageAndCacheShop(into: iv, context: self.context, shop: mapShopCDIntoShop(shopCD: shopCD))
            
            //images
            shopCD.image?.loadImageAndCacheShop(into: iv, context: self.context, shop: mapShopCDIntoShop(shopCD: shopCD), typeImage: "image")
            
            
            //location GoogleMaps Image
            let googleURL : String = "https://maps.googleapis.com/maps/api/staticmap?center=XXX,YYY&zoom=17&size=320x220&scale=2&markers=%7Ccolor:0x9C7B14%7CXXX,YYY"
            
            let urlStringFinal = googleURL.replacingOccurrences(of: "YYY", with: String(describing: shopCD.logitude)).replacingOccurrences(of: "XXX", with: String(describing: shopCD.latitude)).replacingOccurrences(of: ",0.0", with: "")
            
             urlStringFinal.loadImageAndCacheShop(into: iv, context: self.context, shop: mapShopCDIntoShop(shopCD: shopCD), typeImage: "google")
            
        }
        
        //fill maps points
        self.FillMapPoints()
        
        
    }
    


    }
