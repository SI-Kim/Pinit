
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase


class SelectedMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var defaultMarker: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var db = Firestore.firestore()

    var geocoder = GMSGeocoder()
    var selectedPlace: GMSPlace?
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    
    var marker = GMSMarker()

    var items: [Items] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
       loadItems()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false){(timer) in
            
            print(self.items[self.appDelegate.selectedIndexOfRow].address)
            
            
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: self.items[self.appDelegate.selectedIndexOfRow].latitude, longitude: self.items[self.appDelegate.selectedIndexOfRow].longitude), zoom: 15)
            self.mapView.camera = camera
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false){(timer) in

            self.initMapView()
            self.initLocationManager()
        
        
            self.view.bringSubviewToFront(self.defaultMarker)
        }
    }
    
        func initMapView(){
             
             
             mapView = GMSMapView()
            
            let camera = GMSCameraPosition.camera(withLatitude: items[self.appDelegate.selectedIndexOfRow].latitude, longitude: items[self.appDelegate.selectedIndexOfRow].longitude, zoom: 15)
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
            marker = GMSMarker(position: CLLocationCoordinate2D(latitude: items[self.appDelegate.selectedIndexOfRow].latitude, longitude: items[self.appDelegate.selectedIndexOfRow].longitude))
             
         }
    
    
    
    
    
         func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             if let coordi = manager.location?.coordinate {
                 print("위도: ", String(coordi.latitude))
                 print("경도: ", String(coordi.longitude))
                print("Coordinate: ")
                print(coordi)
                
              //            위치가 바뀌었기 때문에, 구글맵의 중심위치(센터)를 옮겨줌.
//                          let camera = GMSCameraPosition.camera(withLatitude: coordi.latitude, longitude: coordi.longitude, zoom: 15)
//                          mapView?.camera = camera
                self.appDelegate.savedCoordinate = coordi
              //            구글맵 이동 시 부드럽게 이동
//                          mapView?.animate(to: camera)
                
                
                      }
   
             }

    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        self.view.bringSubviewToFront(defaultMarker)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool){
        mapView.clear()
        
    }
    
    
    
    
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    //        지오코더를 이용하여 위도, 경도에서 행정주소로 가져올 수 있음.
           
            geocoder.reverseGeocodeCoordinate(position.target){
                (response, error) in
    //            에러가 발생했을때 guard문을 나감
                guard error == nil else {return}
                if let result = response?.firstResult() {
//                    let centeredCord = mapView.camera.target
                    
                    let marker = GMSMarker(position: position.target)
                    marker.position = position.target
                    marker.title = self.items[self.appDelegate.selectedIndexOfRow].title
                    

    //                 행정 주소가 나옴.
                    marker.snippet = result.lines?[0]
                    marker.map = mapView
                    self.appDelegate.savedCoordinate = position.target
                    if result.lines?[0] != nil {
                        self.appDelegate.savedAddress = result.lines![0]
                    }
                }
            }
            
            
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
