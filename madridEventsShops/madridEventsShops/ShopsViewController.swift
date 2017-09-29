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


class ShopsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // CoreData Context
    var context: NSManagedObjectContext!
    
    //outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var shopsCollectionView: UITableView!
    
    //Location
    var locationManager: CLLocationManager?
    var lastMapSelectShop : Shop!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = NSLocalizedString("SHOPS_TITLE", comment: "Title")
             
        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))

        
        // REGISTER SHOPCELL

        //registramos la celda
        shopsCollectionView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: "ShopCell")
        

        
        //User Autorization
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingLocation()
        
        
        //configure the MapKit
        let madridLocation = CLLocation(latitude: 40.416775, longitude: -3.703790)
        self.map.setCenter(madridLocation.coordinate, animated: true)
        
        let region = MKCoordinateRegion(center: madridLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        let reg = self.map.regionThatFits(region)
        self.map.setRegion(reg, animated: true)
        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando datos"))
        
        
        
        self.shopsCollectionView.delegate = self
        self.shopsCollectionView.dataSource = self

        self.FillMapPoints()

        
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
        SVProgressHUD.dismiss()
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("** START LOCATING USER")
        
 
        
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("** STOP LOCATING USER")
        
    }
    
    //error location user
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error){
        print("** ERROR LOCATING USER")
    }
    
    
    //select then pin in map. I'm gooint to get the Shop
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view == mapView.userLocation {
            return
        }
        
        //last select Shop (tap in pin)
        let nota : Note = view.annotation as! Note
        lastMapSelectShop = nota.entity
        
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
            
            view.pinColor = .purple
            view.canShowCallout = true
            view.animatesDrop = true
            
            
            //sacamos el logo de CoreData
            
            let tools = coreDataTools()
            let shopCD = tools.getShopsFilterName(context: self.context, name: annotation.title as! String)
            
            
            if let logoData = shopCD.logo_data{
                let mapsButtom = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
                mapsButtom.setBackgroundImage(UIImage(data: logoData as Data), for: UIControlState())
                
                //creamos un Tap gesture y se lo asignamos al boton
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPin))
                tapGesture.numberOfTouchesRequired = 1  // numero de dedos
                tapGesture.numberOfTapsRequired = 1     // veces que los dedos golpean la pantalla
                mapsButtom.addGestureRecognizer(tapGesture) //añadimos el Gesto al boton
 

                
                
                
                view.rightCalloutAccessoryView = mapsButtom
            } else {
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
        }
        return view
    }
    
    //tap in popup of pin in the map
    @objc func tapPin (){
        
        if let lastShop = lastMapSelectShop{
            //push detail controller
           
            let vcDetail = ShopDetailViewController(shop: lastShop, context: self.context)
            self.navigationController?.pushViewController(vcDetail, animated: true)
            
        }
        
    }
 
    
    
    // Fill All point in the map from CoreData
    
    func FillMapPoints(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let shopsCd : [ShopCD] = obj.getAllShops(context: self.context)
        
        //all items
        for shopCD in shopsCd {
            let location = CLLocation(latitude: CLLocationDegrees(shopCD.latitude), longitude: CLLocationDegrees(shopCD.logitude))
            
            let pin=Note(coordinate: location.coordinate, title: shopCD.name!, subtitle: shopCD.address!, name: shopCD.name!, entity: mapShopCDIntoShop(shopCD: shopCD))
            
            self.map.addAnnotation(pin)

        }
        //piut the delegate
        self.map.delegate = self
        
      }
  
}
