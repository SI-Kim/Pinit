
import UIKit
import Firebase
import GoogleMaps
import FirebaseCore
import FirebaseFirestore

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var db = Firestore.firestore()
    var items: [Items] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        loadItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: const.cellIdentifier, for: indexPath) as! TableViewCell
        cell.savedTitleLabel?.text = items[indexPath.row].title
        cell.savedAddressLabel?.text = items[indexPath.row].address
        Storage.storage().reference(forURL: items[indexPath.row].imageURL).getData(maxSize: Int64.max){(data, error) in
            if let e = error {
                print(e)
                return
                
            }
            cell.savedImageView.image = UIImage.init(data: data!)
        }
        
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.selectedIndexOfRow = indexPath.row
        print("선택한 셀 순서 : ", appDelegate.selectedIndexOfRow)
        print("선택한 지역의 주소 : ", items[indexPath.row].address)
        print("선택한 지역의 좌표 : ", CLLocationCoordinate2D(latitude: items[indexPath.row].latitude, longitude: items[indexPath.row].longitude))
    }
    
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let date = items[(indexPath as NSIndexPath).row].date
//            let docuRef = "Items/" + findDocuID(date: date)
            items.remove(at: (indexPath as NSIndexPath).row)
//            imageRef.delete(completion: nil)
            print("지우고 난 후 items 배열 : ",items)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            Timer.scheduledTimer(withTimeInterval: 5, repeats: false){(timer) in
                
//            }
        
            }else if editingStyle == .insert {
            
        }
        print("db 구문 시작 전")
        db.collection(const.ItemsCollectionName).order(by: const.itemElement.date).addSnapshotListener { (querySnapshot, error) in
            print("db구문 시작")
                       if let e = error {
                           print("Document ID 확인 실패 : ", e)
                       } else {
                        print("Document ID 확인 성공")
                           if let snapshotDocument = querySnapshot?.documents {
                               
                                for doc in snapshotDocument {
                               
                                    let data = doc.data()
                                    let dateToFind = data[const.itemElement.date] as! Double
                                    print(data)
                                }
                            }
                        }
            }
    }
        
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return const.deleteConfirmationButton
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    

}
    
    func findDocuID(date: Double) -> String {
        
        var docuName = String()
         db.collection(const.ItemsCollectionName).order(by: const.itemElement.date).addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocument = querySnapshot?.documents {
                            
                        for doc in snapshotDocument {
                            
                                let data = doc.data()
                            let dateToFind = data[const.itemElement.date] as! Double
                            if date == dateToFind {
                                docuName = doc.documentID 
                                
        //                        imageRef = Storage.storage().reference().child(data[const.itemElement.imageName] as! String)
                            }
                            }
                        }
                        }
                    }
        
        return docuName
        
    }
    
    func deleteFields(docuName: String) {
        
        db.collection(const.ItemsCollectionName).document(docuName).updateData([
            const.itemElement.address : FieldValue.delete(),
            const.itemElement.coordinate : FieldValue.delete(),
            const.itemElement.date : FieldValue.delete(),
            const.itemElement.imageName : FieldValue.delete(),
            const.itemElement.imageURL : FieldValue.delete()])
    }
    
    func findDocuRef(date: Double) -> DocumentReference {
        var docuRef: DocumentReference?
         db.collection(const.ItemsCollectionName).order(by: const.itemElement.date).addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocument = querySnapshot?.documents {
                            
                        for doc in snapshotDocument {
                            
                                let data = doc.data()
                            let dateToFind = data[const.itemElement.date] as! Double
                            if date == dateToFind {
                                docuRef = doc.reference
        //                        imageRef = Storage.storage().reference().child(data[const.itemElement.imageName] as! String)
                            }
                            }
                        }
                        }
                    }
        
        return docuRef!
    }
    
    
}
