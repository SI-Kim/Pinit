# Pinit
**_&lt;Pin it> Application for Potfolio_**


I'm studying for being  Swift developer.
This is my first app for my potfolio.

It's contained following functions.

## Requirements

### Running
iOS 13.00+


### Building
- Xcode 11.0+

- CocoaPods 1.5.3+

## Features
### 1. Authentication ###
  A server was needed to implement this feature. And Firebase can be the best way to that in my environment.
  - **Register**
  
    User can choose log-in or going register page after first view controller. It is able to  join simply by typing an email and password in Register page connected modally with first page.
    After enrolling email, a toast pop-up window show if enrolled successfully. With no button required, can go back to log-in page because register window is connected with log-in page by 'Modally'.
    Whenever registered, can confirm on Authentication tap of Firebase the registered account.

```swift
if let email = emailTextField.text, let password = passwordTextField.text {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        if let e = error {
            print(e.localizedDescription)
        } else {
            print("Registered successfully.")
            self.dismiss(animated: true, completion: nil)
        }
    }
}
```


    
  - **Log In**
  
    Users can log-in to this app with registered e-mail account. if log-in, screen turned over to the table view.
    
```swift
if let email = emailTextField.text, let password = passwordTextField.text{
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
        if let e = error {
            print(e)
        }else{
            print("logged-in successfully")
            self?.performSegue(withIdentifier: const.toMainTableView, sender: self)
        }
    }
}
```
    

### 2. Tableview ###
  Next to the log-in page,  built a table view shown saved items such as titles, images, addresses.
  - **With FireStore**
  
    Users can save some informations such as title, image, address through a item adding page will introduced next line.
    Saved informations are uploaded on Firestore of firebase, we can confirm them on this table view. There some delay for loading from firebase server.
    
    
### 3. Item Adding ###
  Once pressed '+' button on top right corner of the view, the screen changed to adding page through navigation segue. On this page, can select and save a title, geopoint of the site, image.
  - **Setting geopoint With Google Maps**

    Center of this view, there located a container view for Google maps API. Users can select the geopoint of site wanted saved with a pin on center. As dragging the map, can change center of the map.   


  - **Selecting A Image from Photo Library Of Using Device**

    Once press a picture button on bottom of the view, the screen changed to image selecting page from photo library. User can select any image for saving with this informations. The selected image output be resized 100x100.

```swift
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
```

  - **Alert Before Saving**

    When save the information through the 'Save' button on top right corner of the view, if there is no written title, will be pop a alert message. Without title of the information, cannot saved any information.

```swift
func myAlert(_ title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
    }
```


  - **Saving on Firebase**
  
    When pressed the 'Save' button after selecting title, geopoint, image, the informations be uploaded on server. In the database, it be uploaded that the informations of title, image name, date of uploading, geopoint, address. And the image be uploaded on Firestore.

```swift
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
        print("Uploaded successfully!")
       }
    }            
}
```


### 4. Maps ###
  Once press the tap bar button bottom of table view, be shown map screen. We can check all the site through pins on the map.
  - **Pins Setting**

    All of saved sites be displayed by marker. These markers be set by saved coordinate of geopoint. First camera on map is located by first saved geopoint.

    
  - **Snipets Setting**

    There will appear snipets on markers when tab them, and they show the address information.


### 5. Other Features ###
  - **Side Menu**

  Side menu be used by tapping cogwheel shaped button. It has not any additional function so far, but can build additional function such as log-out and binding agreement. This function is made of *Side-menu* cocoa pod.


  - **Toast Popup**

  When register new account, it be popped up the toast message. This made of *Toast-Swift* pod.
