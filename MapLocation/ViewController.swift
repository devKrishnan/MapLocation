//
//  ViewController.swift
//  MapLocation
//
//  Created by radhakrishnan S on 01/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import MapKit
struct Location {
    var name : String
    var geoCodedInfoList : [Any]?
    init(name: String) {
        self.name = name
    }
}
//When more than one item turns up from the API for geocoding, right now we are taking the first item by default. Need to provide action sheet to choose let users choose an address
class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var selectedLocationIndexPath : NSIndexPath?
    var currentAnnotation : Annotation?
    var locations : [Location] = [ Location(name: "Vidhana Soudha"), Location(name: "Cubbon Park"), Location(name: "Venkateswarapuram"), Location(name: "Reddiarpatti"),Location(name: "Puzhuthivakkam")]
    @IBOutlet weak var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor.red
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showErrorMessage(title:String,message:String){
        let alertController : UIAlertController = UIAlertController(title: title    , message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return locations.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let location = locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationNameCell")
        cell?.textLabel?.text = location.name
        return cell!
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        selectedLocationIndexPath = indexPath as NSIndexPath
        if let geoCodedInfoList = locations[indexPath.row].geoCodedInfoList {
            self.showLocation(locationList: geoCodedInfoList as! [[String : AnyObject]])
        }else{
            let apiClient = APIClient(delegate: self)
            apiClient.geoCode(address: locations[indexPath.row].name)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
    }
}
extension ViewController: APIResponse {
    func didSucced(results: Any) -> Void{
        var locationInformation = locations[(selectedLocationIndexPath?.row)!]
        locationInformation.geoCodedInfoList = results as? [Any]
        locations[(selectedLocationIndexPath?.row)!] = locationInformation
        let locationList = results as! [[ String: AnyObject] ]
        DispatchQueue.main.async{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.showLocation(locationList: locationList)
        }
    }
    func didFail(message: String ) -> Void{
        DispatchQueue.main.async{
            self.showErrorMessage(title: "Location Fetch", message: message)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showLocation( locationList : [[ String: AnyObject] ] ) -> Void {
        if (Bool(locationList.count as NSNumber )){
            if let _ = self.currentAnnotation {
                self.mapView.removeAnnotation(self.currentAnnotation!)
            }
            self.currentAnnotation = Annotation(geoCodedInformation: locationList[0])
            self.focusLocation()
        }
    }
   
    func focusLocation (){
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: (currentAnnotation?.coordinate)!, span: span)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
        mapView.addAnnotation(currentAnnotation!)
        
    }
}
extension ViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let view = MKPinAnnotationView(annotation: currentAnnotation, reuseIdentifier: "AnnotationView")
        view.canShowCallout = true
        return view
    }
}
