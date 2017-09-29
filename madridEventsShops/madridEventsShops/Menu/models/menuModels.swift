

import Foundation


public class menuItem {
    
    var id : String
    var title : String?
    var image : String?
    
    public init(id : String){
        self.id = id
    }
    
    public init(id : String, title : String,  image : String){
        self.id = id
        self.title = title
        self.image = image
    }
}

public class menuMain{
    
    private var items = [menuItem]()
    
    public init() {
        
        //Create the menu Items
        
       let m1 = menuItem(id: "01", title: NSLocalizedString("MENU_MADRID_SHOPS_TITLE", comment: "Tiendas de Madrid"),  image: "shop2.png")
       let m2 =   menuItem(id: "02", title: NSLocalizedString("MENU_MADRID_EVENTS_TITLE", comment: "Eventos de  Madrid"), image: "event2.png")
       self.items.append(m1)
       self.items.append(m2)
        
    }
    
    func getItem(atIndex: Int) -> menuItem{
        return self.items[atIndex]
    }
    
    func getCount() -> Int{
        return self.items.count
    }
    
}
