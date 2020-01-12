

import UIKit

class TabbarController: UITabBarController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        


    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let tabbarIndex = tabBarController?.selectedIndex
        if tabbarIndex == 0 {
            let tableView = MainTableViewController()
            tableView.tableView.reloadData()
        } else if tabbarIndex == 1 {
            let mapView = ItemsOnMapViewController()
            DispatchQueue.main.async {
                mapView.loadItems()
                mapView.viewDidLoad()
                
            }
            
            
        }
    }
      
    
    

}
