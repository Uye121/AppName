//
//  TableViewController.swift
//  TestFBAPI
//
//  Created by Richard Du on 4/8/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import MapKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [NSDictionary]?
    var address: String?
    var coordinate: CLLocationCoordinate2D?
    let apiKey = "AIzaSyBPbfAd6wHPyyuJVUVtF7Rtx98W1eIS7cc"
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        var latitude: Double = -33.8670522
        var longitude: Double = 151.1957362
        let radius: Double = 500
        let type: String = ""
        let keyword: String = ""
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address!)") {
            placemarks, error in
            let placemark = placemarks?.first
            self.coordinate = placemark?.location?.coordinate
            
            
        
        latitude = self.coordinate!.latitude
        longitude = self.coordinate!.longitude
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=\(type)&keyword=\(keyword)&key=\(self.apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    print(dataDictionary)
                    self.locations = (dataDictionary["results"] as![NSDictionary])
                    self.tableView.reloadData()
                    
                }
            }
        }
        task.resume()
        }
    }

    @IBAction func onTap(_ sender: Any) {
        keywordTextField.endEditing(true)
        typeTextField.endEditing(true)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        keywordTextField.endEditing(true)
        typeTextField.endEditing(true)
        var latitude: Double = -33.8670522
        var longitude: Double = 151.1957362
        let radius: Double = 500
        let type: String = typeTextField.text!
        let keyword: String = keywordTextField.text!
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("\(address!)") {
            placemarks, error in
            let placemark = placemarks?.first
            self.coordinate = placemark?.location?.coordinate
            
            
            
            latitude = self.coordinate!.latitude
            longitude = self.coordinate!.longitude
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=\(type)&keyword=\(keyword)&key=\(self.apiKey)")
            let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let data = data {
                    if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        
                        print(dataDictionary)
                        self.locations = (dataDictionary["results"] as![NSDictionary])
                        self.tableView.reloadData()
                        
                    }
                }
            }
            task.resume()
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations?.count ?? 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
        
        let location = locations![indexPath.row]
        //print(location)
        
        let geometry = location["geometry"] as! NSDictionary
        let coordinates = geometry["location"] as! NSDictionary
        //let ratings = location["rating"]
        //print(ratings)
        
        let lng = coordinates["lng"] as! NSNumber
        let lat = coordinates["lat"] as! NSNumber
        
        cell.nameLabel.text = (location["name"] as! String)
        //cell.ratingLabel.text = "\(ratings)"
        
        if let photoArray = location["photos"] as? NSArray {
            let photoDict = photoArray[0] as! NSDictionary
                cell.backgroundImage.setImageWith(URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoDict["photo_reference"])&key=\(apiKey)")!)
        }
        if let coordinate = self.coordinate {
        let coordinate₀ = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        let coordinate₁ = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
        let dist = metersToMiles(distance: distanceInMeters)
        cell.distanceLabel.text = "\(Double(dist).truncate(places: 2)) miles"
        }
        return cell
    }
    
    func metersToMiles(distance: CLLocationDistance) -> Double {
        let dist = distance / 1609.34
        
        return dist
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double{
    func truncate(places : Int)->Double{
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}


