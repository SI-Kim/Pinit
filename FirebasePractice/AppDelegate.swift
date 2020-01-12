//
//  AppDelegate.swift
//  FirebasePractice
//
//  Created by 김성일 on 2019/12/20.
//  Copyright © 2019 Skim88.1942. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var selectedIndexOfRow = Int()
    
    var savedAddress = String()
    var savedCoordinate = CLLocationCoordinate2D()
    var savedImage = UIImage()
    
    var savedCoordinates :[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 37.513282, longitude: 127.099994)]
    var savedAddresses = ["Jamsil 6(yuk)-dong, Songpa-gu, Seoul, South Korea"]
    var savedTitles = ["SampleItem"]
    var savedImages: [UIImage] = [#imageLiteral(resourceName: "image4.png")]
    
//    var savedMarker = [GMSMarker()]
//    var selectedMarker: GMSMarker? = GMSMarker()
    var indexOfTappedMarker = Int()
    var catchChageFlag = Bool()
    var userID = String()
    
    
    
    var mySidemenu: MySideMenuNavigationController? = nil
    var mainVC: FirstNavigationController? = nil
    
    
    var countItemHave = 0
    var imageName = String()
    var imageURL: URL? = nil
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyAk7978FZOfpCv-W52lT8xkkdJXEATcr5o")
    GMSPlacesClient.provideAPIKey("AIzaSyAk7978FZOfpCv-W52lT8xkkdJXEATcr5o")
        
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

