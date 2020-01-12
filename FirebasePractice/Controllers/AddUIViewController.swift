
import UIKit
import MobileCoreServices
import Toast_Swift
import Firebase

class AddUIViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    var db = Firestore.firestore()

    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var defaultMarker: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var Photo: UIImageView!
    
    
    
    
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var flagImageSave = false
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
    }
    
    
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
          myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
        
    }
    
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            
            }
            let resizedImage = captureImage.convert(toSize:CGSize(width:100.0, height:100.0), scale: UIScreen.main.scale)
            Photo.image = resizedImage
            
        } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            myAlert("Can select only a picture", message: "Please select not any video file, a picture file.")
            dismiss(animated: true, completion: nil)
            present(imagePicker, animated: true, completion: nil)
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
    let storage = Storage.storage()
    let storageRef = storage.reference()
      let data = Photo.image!.pngData()
            
    
    let timestamp = Int(NSDate.timeIntervalSinceReferenceDate * 1000)
    let uniqueImageFileName = "image" + String(timestamp) + ".png"
    let serverImageRef = storageRef.child(uniqueImageFileName)
    appDelegate.imageName = uniqueImageFileName

    let metadata = StorageMetadata()
    metadata.contentType = "image/png"
            
    let uploadTask = serverImageRef.putData(data!, metadata: metadata) {
                        (metadata, error) in
        guard let metadata = metadata else {
            return
        }
    let size = metadata.size
    serverImageRef.downloadURL{
        (url, error) in
       
    guard let downloadURL = url else {
        return
    }
        self.appDelegate.imageURL = downloadURL

    print("업로드 성공함!")

                }
            }

            
        }
    
    
    
    @IBAction func onBtnSave(_ sender: UIBarButtonItem) {
        if titleTextField.text == "" {
            myAlert("Didn't write title", message: "Please write the title of this item.")
//            myAlert("Write the title", message: "Please write the title of this item.")
            return
        } else {
            uploadImage()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false){(timer) in
                if let imageURLasString = self.appDelegate.imageURL?.absoluteString{
                let imageName = self.appDelegate.imageName
                let coordinate = GeoPoint(latitude: self.appDelegate.savedCoordinate.latitude, longitude: self.appDelegate.savedCoordinate.longitude)
                print("title : \(self.titleTextField.text!)\n",
                    "userEmail : \(Auth.auth().currentUser?.email)",
                    "coordinate : \(self.appDelegate.savedCoordinate)",
                    "address : \(self.appDelegate.savedAddress)",
                      "imageName : \(self.appDelegate.imageName)\n",
                      "imageUrl : \(imageURLasString)")
                    if let title = self.titleTextField.text, let email = Auth.auth().currentUser?.email {
                    
                    self.db.collection("Items").addDocument(data: [const.itemElement.title : title,
                                                                    const.itemElement.userEmail : email,
                                                                    const.itemElement.date : Date().timeIntervalSince1970,
                                                                    const.itemElement.imageName : imageName,
                                                                    const.itemElement.imageURL : imageURLasString,
                                                                    const.itemElement.address : self.appDelegate.savedAddress,
                                                                    const.itemElement.coordinate : coordinate])
                
            }
                print("Successfully saved.")
                }
                }
        
        }
        
        moveToMainTableView()
        
        self.view.makeToast("저장되었습니다.", duration: 2.0, position: .bottom)
        
    }
    
    func moveToMainTableView() {
        let vcIndex = self.navigationController?.viewControllers.firstIndex(where: { (viewController) -> Bool in
            if let _ = viewController as? MainTableViewController {
                return true
            }
            return false
        })
        let mainTableViewController = self.navigationController?.viewControllers[vcIndex!] as! MainTableViewController
        navigationController?.popToViewController(mainTableViewController, animated: true)
    }
    
    
}

extension UIImage
{
    // convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return copied!
    }
}
