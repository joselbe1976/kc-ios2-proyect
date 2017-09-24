

import UIKit
import SVProgressHUD


class MenuTableViewController: UITableViewController {
    
    var menu : menuMain?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.menu  = menuMain()

        
        //registramos la celda
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")

        
        SVProgressHUD.show(withStatus: NSLocalizedString("GLOBAL_LOAD_DATA", comment: "Cargando Datos"))
        
        
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
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
   

    
    
}
