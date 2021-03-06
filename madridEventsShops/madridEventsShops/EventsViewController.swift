//
//  EventsViewController.swift
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



class EventsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // CoreData Context
    var context: NSManagedObjectContext!
    
    //outlets
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var CollectionView: UITableView!
    
    //Location
    var locationManager: CLLocationManager?
    var lastMapSelectEvent : Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("EVENTS_TITLE", comment: "Title")

        
        
        // REGISTER SHOPCELL
        
        //registramos la celda
        CollectionView.register(UINib(nibName: "ShopCell", bundle: nil), forCellReuseIdentifier: "ShopCell")
        
        
        
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

        
        self.CollectionView.delegate = self
        self.CollectionView.dataSource = self
        
        self.FillMapPoints()

        
    }
    
  
    
    // MARK: - Fetched results controller
    var _fetchedResultsController: NSFetchedResultsController<EventCD>? = nil
    
    var fetchedResultsController: NSFetchedResultsController<EventCD> {
        if (_fetchedResultsController != nil) {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<EventCD> = EventCD.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        // fetchRequest == SELECT * FROM EVENT ORDER BY TIMESTAMP DESC
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context!, sectionNameKeyPath: nil, cacheName: "EventsCacheFile")
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
       
        //last select Shop (tap in pin)
        do{
            let nota : Note = try view.annotation as! Note
            lastMapSelectEvent = nota.entity as! Event
        }
        catch {
            print("error mapkit pin get")
        }
   

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
            let eventCD = tools.getEventFilterName(context: self.context, name: annotation.title as! String)
           
            
            if let logoData = eventCD.logo_data{
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
        
        if let lastEvent = lastMapSelectEvent{
            //push detail controller
            
            let vcDetail =  EventDetailViewController(event: lastEvent, context: self.context)
            self.navigationController?.pushViewController(vcDetail, animated: true)
            
        }
        
    }
    

    
    
    // Fill All point in the map from CoreData
    
    func FillMapPoints(){
        
        //leemos todas las tiendas
        let obj = coreDataTools()
        let eventsCD : [EventCD] = obj.getAllEvents(context: self.context)
        
        //all items
        for eventCD in eventsCD {
            let location = CLLocation(latitude: CLLocationDegrees(eventCD.latitude), longitude: CLLocationDegrees(eventCD.logitude))
            
            let n=Note(coordinate: location.coordinate, title: eventCD.name!, subtitle: eventCD.address!, name: eventCD.name!, entity: mapEventCDIntoEvent(eventCD: eventCD) as Shop)
            self.map.addAnnotation(n)
            
        }

        
        if eventsCD.count > 0 {
            //put the delegate
            self.map.delegate = self
        }
    }
    
   
    
    

   

}
