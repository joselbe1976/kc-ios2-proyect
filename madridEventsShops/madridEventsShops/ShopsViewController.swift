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

class Note: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
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
        
        // REGISTER SHOPCELL

        //registramos la celda
        shopsCollectionView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: "ShopCell")
        

        
        //User Autorization
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        self.map.delegate = self
        locationManager?.startUpdatingLocation()
        
        
        let londonLocation = CLLocation(latitude: 40.5073509, longitude: 0.1277583)
        self.map.setCenter(londonLocation.coordinate, animated: true)
        
        let region = MKCoordinateRegion(center: londonLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        let reg = self.map.regionThatFits(region)
        self.map.setRegion(reg, animated: true)
        
        
        let n=Note(coordinate: londonLocation.coordinate, title: "Hello", subtitle: "Hello sub")
        self.map.addAnnotation(n)

        
        
        //Load Data from Json If is not store
        ExecuteOnceInteractorImpl().execute {
            initializeData()
        }
        
        self.shopsCollectionView.delegate = self
        self.shopsCollectionView.dataSource = self
        
        
    }
    

    
    func initializeData() {
        let downloadShopsInteractor: DownloadAllShopsInteractor = DownloadAllShopsInteractorNSURLSessionImpl()
        
        downloadShopsInteractor.execute { (shops: Shops) in
            // todo OK
            
            let cacheInteractor = SaveAllShopsInteractorImpl()
            cacheInteractor.execute(shops: shops, context: self.context, onSuccess: { (shops: Shops) in
                SetExecutedOnceInteractorImpl().execute()
                
                self._fetchedResultsController = nil
                self.shopsCollectionView.delegate = self
                self.shopsCollectionView.dataSource = self
                self.shopsCollectionView.reloadData()
            })
        }
    }
   
    
    //  Select a Shop
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shop: ShopCD = self.fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "ShowShopDetailSegue", sender: shop)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowShopDetailSegue" {
            let vc = segue.destination as! ShopDetailViewController
            
            let shopCD: ShopCD = sender as! ShopCD
            vc.shop = mapShopCDIntoShop(shopCD: shopCD)
        }
    }
 */
    
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



    }
