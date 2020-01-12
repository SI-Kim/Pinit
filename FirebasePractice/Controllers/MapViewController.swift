
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var defaultMarker: UIImageView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    

    var geocoder = GMSGeocoder()
    var selectedPlace: GMSPlace?
    var placesClient: GMSPlacesClient!
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!

    
    override func viewWillAppear(_ animated: Bool) {
        self.defaultMarker.layer.zPosition = 5
        self.mapView.layer.zPosition = -5
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        initLocationManager()
        


    }
    
        func initMapView(){
             
             
             mapView = GMSMapView()
            
             let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 15)
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
    
    
    
    
    
         func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
             if let coordi = manager.location?.coordinate {
                 print("위도: ", String(coordi.latitude))
                
                 print("경도: ", String(coordi.longitude))
                print("Coordinate: ")
                print(coordi)
                
              //            위치가 바뀌었기 때문에, 구글맵의 중심위치(센터)를 옮겨줌.
                          let camera = GMSCameraPosition.camera(withLatitude: coordi.latitude, longitude: coordi.longitude, zoom: 15)
                          mapView?.camera = camera
//                self.appDelegate.savedCoordinate = coordi
              //            구글맵 이동 시 부드럽게 이동
                          mapView?.animate(to: camera)
                
                
                      }
   
             }
    var marker = GMSMarker()
    
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
                    let centeredCord = mapView.camera.target

                    let marker = GMSMarker(position: centeredCord)
                    marker.position = position.target
                    marker.title = const.currentPosition

    //                 행정 주소가 나옴.
                    marker.snippet = result.lines?[0]
                    marker.map = mapView
                    if result.lines?[0] != nil {
                        self.appDelegate.savedAddress = result.lines![0]
                        self.appDelegate.savedCoordinate = position.target
                    }
                }
            }
            
            
        }

    
    
}
