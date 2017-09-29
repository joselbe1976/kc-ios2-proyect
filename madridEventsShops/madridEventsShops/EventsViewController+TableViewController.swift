//
//  EventsViewController+TableViewController.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 26/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit

extension EventsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create the cell
        let cell : ShopCell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath) as! ShopCell
        
        let eventCD: EventCD = fetchedResultsController.object(at: indexPath)
        
        let event = mapEventCDIntoEvent(eventCD: eventCD)
        let shop = event as Shop
        
        cell.refresh(shop: shop, context: self.context)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    //selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //push detail controller
        let eventCD: EventCD = fetchedResultsController.object(at: indexPath)
        let vcDetail = EventDetailViewController(event : mapEventCDIntoEvent(eventCD: eventCD) ,context: self.context)
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
    
}
