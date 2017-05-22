//
//  AppDelegate.swift
//  Afrisia
//
//  Created by mobile on 4/17/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Google Service Settings
        GMSServices.provideAPIKey(Constants.GoogleAPIKey)
        GMSPlacesClient.provideAPIKey(Constants.GoogleAPIKey)
        
        // CLLocationManager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100.0
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        Fabric.with([Crashlytics.self])
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options [UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options [UIApplicationOpenURLOptionsKey.annotation])
        
        return handle
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    class func appDelegate () -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    // MARK: - CLLocation
    
    // Enable Location
    func requestLocationAuthenticating() {
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.checkLocationServiceStatus()
    }
    
    // Get Location
    func getLocation() -> CLLocation? {
        let userDefault = UserDefaults.standard
        let latitude = userDefault.value(forKey: UserAuth.keyLatitude) as? CLLocationDegrees
        let longitude = userDefault.value(forKey: UserAuth.keyLongitude) as? CLLocationDegrees
        
        if latitude == nil && longitude == nil {
            if CLLocationManager.locationServicesEnabled() {
                let status = CLLocationManager.authorizationStatus()
                switch status {
                case .authorizedWhenInUse:
                    if let location = self.locationManager.location {
                        return location
                    } else {
                        self.locationManager.requestWhenInUseAuthorization()
                        self.locationManager.startUpdatingLocation()
                    }
                    break
                default:
                    break
                }
            }
        } else {
            return CLLocation(latitude: latitude!, longitude: longitude!)
        }
        
        return nil
    }
    
    func getAddressFromLocation(latitude:CLLocationDegrees, longitude :CLLocationDegrees, completionBlock: @escaping ((CLPlacemark?) -> Void)) {
        
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                
                completionBlock(pm)
                
            } else {
                print("Problem with the data received from geocoder")
                
                completionBlock(nil)
            }
        })

    }
    
    func checkLocationServiceStatus(){
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted :
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            case .denied :
                self.displayAlertViewForDisableLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
            }
        } else {
            self.displayAlertViewForDisableLocation()
            print("Location services are not enabled")
        }
    }
    
    func displayAlertViewForDisableLocation(){
        let alertController = UIAlertController(title: "Location Sevice are disabled", message: "Enabling Location Service, allows Cambi to help you find nearby stores and share with you, special offers by merchants", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Don't Allow", comment: "don't allow title"), style: .cancel) { (action:UIAlertAction!) in
            // Redirect to Location screen
            print("Cancel Alert");
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: NSLocalizedString("Allow", comment: "allow title"), style: .default) { (action:UIAlertAction!) in
            
            let url = NSURL(string:UIApplicationOpenSettingsURLString ) as! URL
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            else{
                print("not able to open URL")
            }
        }
        alertController.addAction(OKAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion:nil)
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.checkLocationServiceStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(CLLocationManager.locationServicesEnabled())
        print(CLLocationManager.authorizationStatus())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didupdatelocation", locations.last!)
        let location = locations.last
        let userDefault = UserDefaults.standard
        userDefault.set(location?.coordinate.latitude, forKey: UserAuth.keyLatitude)
        userDefault.set(location?.coordinate.longitude, forKey: UserAuth.keyLongitude)
        userDefault.synchronize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdatedLocationManager"), object: nil)
    }
}

