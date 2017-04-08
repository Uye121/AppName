//
//  InitialViewController.swift
//  AppName
//
//  Created by Ulric Ye on 4/8/17.
//  Copyright © 2017 uye. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class InitialViewController: UIViewController, CLLocationManagerDelegate {
    
    var placesClient: GMSPlacesClient!
    var locationManager : CLLocationManager!
    @IBOutlet weak var filterSlider: UISlider!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationField: UITextField!
    
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        placesClient = GMSPlacesClient.shared()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func touchSlider(_ sender: Any) {
        distanceLabel.text = "\(Int(filterSlider.value))"
    }
    
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    
                    self.address = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    
                    self.performSegue(withIdentifier: "SearchSegue", sender: nil)
                }
            }
        })
    }
    
    @IBAction func onTap(_ sender: Any) {
        locationField.endEditing(true)
    }
    
    @IBAction func getLocation(_ sender: Any) {
        self.address = "\(locationField.text) USA"
        self.performSegue(withIdentifier: "SearchSegue", sender: nil)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SearchLocation" {
            let tableVC = segue.destination as! TableViewController
            
        }
        if segue.identifier == "SearchSegue" {
            let tableVC = segue.destination as! TableViewController
            tableVC.address = self.address
        }
        if segue.identifier == "Settings" {
            let settingVC = segue.destination as! SettingViewController
            // Do nothing
        }
    }
    
        
}
