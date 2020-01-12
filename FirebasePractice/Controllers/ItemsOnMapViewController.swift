
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase


class ItemsOnMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db = Firestore.firestore()
    var items: [Items] = []

    var geocoder = GMSGeocoder()
    var selectedPlace: GMSPlace?
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    var preTappedMarkerIndex = Int()
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("로드 전 : ", items)
        loadItems()
        print("로드 후 : ", items)
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false){(timer) in
                
                
                
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: self.items[0].latitude, longitude: self.items[0].longitude), zoom: 15)
                self.mapView.camera = camera
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        Timer.scheduledTimer(withTimeInterval: 7, repeats: false){(timer) in

            self.initMapView()
            self.initLocationManager()
            self.markPlaces()

        }
    }
    
    
    
    
     func initMapView(){
             
             
             mapView = GMSMapView()
            
        let camera = GMSCameraPosition.camera(withLatitude: items[0].latitude, longitude: items[0].longitude, zoom: 15)
             mapView.camera = camera
             
             
             mapView.settings.myLocationButton = true
             mapView.isMyLocationEnabled = true
             mapView.delegate = self
                        
             self.view = mapView
             
         }
        
         func initLocationManager(){
    
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
             locationManager.delegate = self
             
             locationManager.requestWhenInUseAuthorization()
             
             locationManager.startUpdatingLocation()
             placesClient = GMSPlacesClient.shared()
            
             
         }
    
    
    
    
  
    func markPlaces() {
        for markNumber in 0 ..< items.count {
            let marks = GMSMarker()
            marks.position = CLLocationCoordinate2D(latitude: items[markNumber].latitude, longitude: items[markNumber].longitude)
            marks.title = items[markNumber].title
            marks.snippet = items[markNumber].address
            marks.map = mapView
            print(marks.position)
            
        }
        
    }
    
    
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
//
//        switch preTappedMarkerIndex {
//        case nil:
//                   for i in 0 ..< self.appDelegate.savedTitles.count {
//
//                    if self.appDelegate.savedTitles[i] == marker.title {
//                        self.appDelegate.indexOfTappedMarker = i
//                        preTappedMarkerIndex = i
//                    }
//                }
//            break
//        case self.appDelegate.indexOfTappedMarker:
//            return true
//        default:
//                    for i in 0 ..< self.appDelegate.savedTitles.count {
//
//                     if self.appDelegate.savedTitles[i] == marker.title {
//                         self.appDelegate.indexOfTappedMarker = i
//                         preTappedMarkerIndex = i
//                     }
//                 }
//        break
//        }
//        let allItems = AllItemMapViewController()
//        allItems.labelOfName.text = self.appDelegate.savedTitles[self.appDelegate.indexOfTappedMarker]
//        allItems.photoView.image = self.appDelegate.savedImages[self.appDelegate.indexOfTappedMarker]
//        return true
//    }
    
    
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
