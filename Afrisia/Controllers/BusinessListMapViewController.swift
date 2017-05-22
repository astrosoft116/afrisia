//
//  BusinessListMapViewController.swift
//  Afrisia
//
//  Created by mobile on 4/21/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import MapKit
import DropDown
import GoogleMaps
import CoreLocation
import Alamofire

class BusinessListMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var filterTypeView: UIView!
    @IBOutlet weak var filterTypeLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var businessCountLabel: UILabel!
    
    var searchDistance: Double = 100
    var resultLimitedCount: Int = 50
    var displayedCount: Int = 0
    
    var filterTypeDropdown: DropDown!
    var businessArray: [BusinessModel] = [BusinessModel]()
    var searchItem = SearchItemModel()
    
    var path : GMSPath?
    var polyLine : GMSPolyline?
    var mapView: GMSMapView!
    
    var selectedIndex: Int = 0
    
    var filterTypeList: [String] = ["Note", "Proximité", "Moyenne"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let userDefault = UserDefaults.standard
        if let searchDistance = userDefault.value(forKey: UserAuth.searchDistance){
            self.searchDistance = searchDistance as! Double
        }  else {
            userDefault.set(self.searchDistance,forKey: UserAuth.searchDistance)
            
            userDefault.synchronize()
        }
        
        if let resultCount = userDefault.value(forKey: UserAuth.resultCount) as? Int {
            self.resultLimitedCount = resultCount
        }  else {
            userDefault.set(self.resultLimitedCount,forKey: UserAuth.resultCount)
            userDefault.synchronize()
        }
        
        self.getBusinessList()
        
        self.setupFiterTypeDropdownMenu ()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadMapView()
        
    }
    
    func getBusinessList(){
        
        if self.businessArray.count > self.resultLimitedCount {
            self.displayedCount = self.resultLimitedCount
        } else {
            self.displayedCount = self.businessArray.count
        }

  
        
        if self.displayedCount > 1 {
            self.businessCountLabel.text = String(self.displayedCount) + " Résultats"
        } else {
            self.businessCountLabel.text = String(self.displayedCount) + " Résultat"
        }

        
        
    }
    
   

    func loadMapView() {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 10, longitude: 10, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
        mapContainerView.addSubview(mapView)
        
        mapView.delegate = self
             
        var index: Int = 0
        
        var bounds = GMSCoordinateBounds()
        
        for business in businessArray {
            
            if index < self.displayedCount {
                // Creates a marker in the center of the map.
                
                var favoritStatusIcon : UIImage
                if business.isFavorite {
                    favoritStatusIcon = AfrisiaImage.favoritMapIcon.image
                } else {
                    favoritStatusIcon = AfrisiaImage.unfavoritMapIcon.image
                }
                
                let drawText = String(business.rateScore)
                let imageWithText = CommonUtils.sharedInstance.textToImage(drawText: drawText as NSString, inImage: favoritStatusIcon, atPoint: CGPoint(x: 10.0, y: 13.0))
                let markerView = UIImageView(image: imageWithText)
                
                let lat = Double(business.latitude!)
                let lng = Double(business.longitude!)
                
                let position = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
                let marker = GMSMarker(position: position)
                bounds = bounds.includingCoordinate(marker.position)
                
                marker.iconView = markerView
                marker.tracksViewChanges = true
                marker.map = mapView
                marker.index(ofAccessibilityElement: index)
                marker.title = String(index)
                index += 1
                
            }
            
        }
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
        
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let index = Int(marker.title!)
        
        self.selectedIndex = index!
        
        let business = businessArray[index!] as BusinessModel
        
        // Get Screens Size
        let bounds = UIScreen.main.bounds
        let widthOfScreen = bounds.size.width
        
        
        let infoWindow = Bundle.main.loadNibNamed("CustomInfoView", owner: self, options: nil)?.first as! CustomInfoView
        
        infoWindow.frame =  CGRect(x: 0, y: 0, width: widthOfScreen * 0.95, height: widthOfScreen * 0.35)
//        infoWindow.layer.borderColor = UIColor.orange.cgColor
//        infoWindow.layer.borderWidth = 1
        
        infoWindow.businessImage.af_setImage(withURL: business.photoUrl!)
        infoWindow.businessNameLabel.text = business.name!
        infoWindow.businessTypeLabel.text = "[" + business.type! + "]"
        infoWindow.distanceLabel.text = String(Int(business.distance)) + "m"
        
        for i in 0...infoWindow.labels.count-1{
            infoWindow.labels[i].text = ""
        }
        if business.labelDetails.count > 0 {
            for i in 0 ... business.labelDetails.count-1 {
                infoWindow.labels[i].text = "[" +  business.labelDetails[i].name! + "]"
            }
        }
        
        
        if business.isFavorite {
            infoWindow.favoritStatutsImage.image = AfrisiaImage.favoritIcon.image
        } else {
            infoWindow.favoritStatutsImage.image = AfrisiaImage.unfavoritIcon.image
        }
        
        infoWindow.locationLabel.text = business.city
        
        infoWindow.rateLabel.text = String(business.rateScore)
        
        return infoWindow
    }

    
    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func chooseFitlerButtonAction(_ sender: Any) {
        self.filterTypeDropdown.show()
    }
  
    @IBAction func goToSettingsButtonAction(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.navigationController?.pushViewController(settingsViewController, animated: true)
        
        
        
    }
    
    @IBAction func itenaryButtonAction(_ sender: Any) {
        
        let business = self.businessArray[selectedIndex]
        let location = CLLocation(latitude: CLLocationDegrees(Float(business.latitude!)!), longitude: CLLocationDegrees(Float(business.longitude!)!))
        let currentPosition = AppDelegate.appDelegate().getLocation()!.coordinate
        let marker = GMSMarker(position: currentPosition)

        
       
        marker.tracksViewChanges = true
        marker.map = mapView

        
        self.drawRoute(origin: AppDelegate.appDelegate().getLocation()!, destination: location, zoomCamera: true) { (polyline) in
            self.animateRoute(polyline: polyline as! GMSPolyline, origin: currentPosition, destination: location.coordinate, pathColor: UIColor.blue, zoomCamera: true)
        }

    }
   

    func setupFiterTypeDropdownMenu () {
        self.filterTypeDropdown = DropDown(anchorView: filterTypeView)
        self.filterTypeDropdown.dataSource = filterTypeList
        self.filterTypeDropdown.dismissMode = .onTap
        self.filterTypeDropdown.bottomOffset = CGPoint(x: 0, y: self.filterTypeView.frame.size.height)
        self.filterTypeDropdown.backgroundColor = UIColor.white
        self.filterTypeDropdown.selectRow(at: 0)
        
        self.filterTypeDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.filterTypeDropdown.selectionAction = {(index: Int, item: String) in
            
            
            self.filterTypeLabel.text = item
            
            
        }
        
    }
    
    func drawRoute(origin: CLLocation, destination: CLLocation, zoomCamera : Bool!, completionHandler: @escaping (_ polyline : AnyObject) -> Void)
    {
        let key : String = Constants.GoogleAPIKey
        
        let originString: String = "\(origin.coordinate.latitude),\(origin.coordinate.longitude)"
        
        let destinationString: String = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        
        let directionsAPI: String = "https://maps.googleapis.com/maps/api/directions/json?"
        
        let directionsUrlString: String = "\(directionsAPI)&origin=\(originString)&destination=\(destinationString)&key=\(key)"
        
        Alamofire.request(directionsUrlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
            if let JSON = response.result.value as? [String: AnyObject] {
                    let routesArray : NSArray = JSON["routes"] as! NSArray
                    
                    if routesArray.count > 0 {
                        
                        let routeDic = routesArray[0] as? [String: AnyObject]
                        
                        let routeOverviewPolyline = routeDic?["overview_polyline"]
                        
                        let points : String = routeOverviewPolyline!["points"] as! String
                        
                        
                        // Creating Path between source and destination.
                        self.path = GMSPath(fromEncodedPath: points)
                        
                        if self.polyLine != nil
                        {
                            self.polyLine?.map = nil
                        }
                        
                        self.polyLine  = GMSPolyline(path: self.path)
                        
                        self.polyLine?.strokeWidth = 3.5
                        
                        self.polyLine?.geodesic = true
                        
                        self.animateRoute(polyline: self.polyLine!, origin: origin.coordinate, destination: destination.coordinate, pathColor:UIColor.blue, zoomCamera: zoomCamera)
                        
                        completionHandler(self.polyLine!)
                    }
            }
        }
    }
    
    
    
    
    func animateRoute(polyline : GMSPolyline, origin : CLLocationCoordinate2D, destination : CLLocationCoordinate2D, pathColor : UIColor, zoomCamera : Bool!)
    {
        
        polyline.strokeColor = pathColor
        
        polyline.map = mapView // Drawing route
        
        let bounds = GMSCoordinateBounds(path: path!)
        
        let pad : CGFloat = 50.0
        
        if zoomCamera == true
        {
            zoomCameraWithBounds(bounds: bounds, pad: pad)
        }
    }
    
    /**
     It will zoom the camera at specific bounds
     
     - parameter bounds: Bounds around which the camera should zoom
     - parameter pad:    Padding value from the edges of the window.
     */
    func zoomCameraWithBounds(bounds : GMSCoordinateBounds, pad : CGFloat)
    {
        let camera = self.mapView.camera(for: bounds, insets:UIEdgeInsets.zero)
        
        self.mapView.camera = camera!
        
        let zoomCamera = GMSCameraUpdate.fit(bounds, withPadding: pad)
        
        self.mapView.animate(with: zoomCamera) // Above lines will update map camera to fit to bounds so that the complete route between source and destination is visible.
    }


}
