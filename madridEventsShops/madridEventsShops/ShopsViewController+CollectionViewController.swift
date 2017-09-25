//
//  ShopsViewController+CollectionViewController.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 24/9/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//

import UIKit

extension ShopsViewController : UITableViewDelegate, UITableViewDataSource {
    
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
       
        let shopCD: ShopCD = fetchedResultsController.object(at: indexPath)
        
        cell.refresh(shop: mapShopCDIntoShop(shopCD: shopCD), context: self.context)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 95
    }
    
    //selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //push detail controller
        let shopCD: ShopCD = fetchedResultsController.object(at: indexPath)
        let vcDetail = ShopDetailViewController(shop: mapShopCDIntoShop(shopCD: shopCD), context: self.context)
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }
    
}
