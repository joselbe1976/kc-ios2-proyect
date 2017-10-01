//
//  Reachability.swift
//  madridEventsShops
//
//  Created by JOSE LUIS BUSTOS ESTEBAN on 1/10/17.
//  Copyright © 2017 jose luis Bustos. All rights reserved.
//


import Foundation
import UIKit
import ReachabilitySwift


class connectionControl : NSObject{
    let reachability = Reachability()!
    
    var laststatus : Bool
    var clausure : ()->Void?
    
    
    
    override init()
    {
        
        laststatus = false  //control execution download one time only
        
        func nada()->Void{}
        
        self.clausure = nada
        
    }
    
    
    //construcctor class.
    convenience init(observador : Bool, clausure: @escaping ()->Void){
        
        self.init();
        
        self.clausure = clausure
       
        
        if (observador == true){
            
            //create a observator
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
            
            
            do{
                try self.reachability.startNotifier()
            }catch{
                print("could not start reachability notifier")
            }
        }
    }
    
    
    // destructor
    deinit {
        stopNotifier()
    }
    
    
    //observer
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        
        // delay 1 seconds . Frameworks delay some time
        delay(0.5){
            
            let rea = note.object as! Reachability
            
            
            
            if rea.isReachable {
               
                //if not executed, executed one timeself.clausure()
                if self.laststatus == false {
                    self.clausure()
                }
                
                
            } else {
                
                
                    // Show a message
                    let alert = UIAlertController(title: "", message: NSLocalizedString("INTERNET_NO", comment: "Sin conexion de datos"), preferredStyle: UIAlertControllerStyle.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
                
            }
            
            
        }
    }
    
    
    // Stop Notifier
    func stopNotifier() {
        print("--- stop notifier")
        self.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: nil)
    }
    
    
    
    //Call for get status connection without observer
    
    func getReachability()->Int {
        
        
        if self.reachability.isReachable {
            if self.reachability.isReachableViaWiFi {
                return 1 //wifi
            } else {
                return 2 //Celular
            }
        } else {
            return -1 //sin conexion
        }
        
    }
    
    
    
    //Delay function
    func delay(_ delay:Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
        
    }
}

