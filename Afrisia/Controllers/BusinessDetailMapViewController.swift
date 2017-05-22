//
//  BusinessDetailMapViewController.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import GoogleMaps

class BusinessDetailMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    
    var business: BusinessModel!
    var lat: CLLocationDegrees = CLLocationDegrees()
    var lng: CLLocationDegrees = CLLocationDegrees()
    var rate : Float = Float()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = business.name
        
        lat = CLLocationDegrees(Float(business.latitude!)!)
        lng = CLLocationDegrees(Float(business.longitude!)!)
        rate = Float(business.rateScore)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadMapView()
        
    }
    
    func loadMapView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: mapContainerView.bounds, camera: camera)
        mapContainerView.addSubview(mapView)
        
        mapView.delegate = self
        
        var favoritStatusIcon : UIImage
        if business.isFavorite {
            favoritStatusIcon = AfrisiaImage.favoritMapIcon.image
        } else {
            favoritStatusIcon = AfrisiaImage.unfavoritMapIcon.image
        }
        
        let drawText = String(business.rateScore)
        let imageWithText = CommonUtils.sharedInstance.textToImage(drawText: drawText as NSString, inImage: favoritStatusIcon, atPoint: CGPoint(x: 10.0, y: 13.0))
        let markerView = UIImageView(image: imageWithText)
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)

        marker.iconView = markerView
        marker.tracksViewChanges = true
        marker.map = mapView
       
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
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
        
        for i in 0 ... business.labelDetails.count-1 {
            infoWindow.labels[i].text = "[" +  business.labelDetails[i].name! + "]"
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
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print(marker.infoWindowAnchor.x)
        print(marker.infoWindowAnchor.y)


        mapView.selectedMarker = nil
    }
    
   

    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }


}
