

import UIKit
import GoogleMaps
import Firebase

class AllItemMapViewController: UIViewController {


    @IBOutlet weak var mapContainerView: UIView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let itemsOnMap = ItemsOnMapViewController()
    
    var db = Firestore.firestore()
    var items: [Items] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        
    }
    
    func updateItems() {
        viewWillAppear(true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
//        if self.appDelegate.selectedMarker != nil {
//            let indexOfMarker = self.appDelegate.savedMarker.firstIndex(of: self.appDelegate.selectedMarker!)
//            labelOfName.text = self.appDelegate.savedTitles[indexOfMarker!]
//            photoView.image = self.appDelegate.savedImages[indexOfMarker!]
//            
//        }
        
        
        
    }
    
    
    func loadItems() {

        db.collection(const.ItemsCollectionName).order(by: const.itemElement.date).addSnapshotListener { (querySnapshot, error) in
                self.items = []

                if let e = error {
                    print(e)
                } else {
                    if let snapshotDocument = querySnapshot?.documents {
                        
                    for doc in snapshotDocument {
                        
                        let data = doc.data()

                        if let title = data[const.itemElement.title] as? String, let email = data[const.itemElement.userEmail] as? String, let date = data[const.itemElement.date] as? Double, let imageName = data[const.itemElement.imageName] as? String, let imageURL = data[const.itemElement.imageURL] as? String, let address = data[const.itemElement.address] as? String, let geopoint = data[const.itemElement.coordinate] as? GeoPoint{
                            let lattitude = geopoint.latitude
                            let longitude = geopoint.longitude
                            if Auth.auth().currentUser?.email == email {
                            let newItem = Items(title: title, userEmail: email, date: date, imageURL: imageURL, imageName: imageName, longitude: longitude, latitude: lattitude, address: address)
                                self.items.append(newItem)
                            }
                        }
                    }
                }
            }
                print(self.items)
        }

    }
    

}
