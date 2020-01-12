
import UIKit

class SideMenuViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var userIDLabel: UILabel!
    
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()




    }
    
    override func viewWillAppear(_ animated: Bool) {
        userIDLabel.text = self.appDelegate.userID
    }
    

    
    
    
//
//    func moveToMainTableView() {
//        let vcIndex = self.navigationController?.viewControllers.firstIndex(where: { (viewController) -> Bool in
//            if let _ = viewController as? MainTableViewController {
//                return true
//            }
//            return false
//        })
//        let mainTableViewController = self.navigationController?.viewControllers[vcIndex!] as! MainTableViewController
//        navigationController?.popToViewController(mainTableViewController, animated: true)
//    }
    
    
    
}
