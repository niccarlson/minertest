//
//  ViewController.swift
//  minertest
//
//  Created by nic on 2/25/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import MapKit
import MapKitGoogleStyler
import CoreLocation
import Firebase
import FirebaseUI

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    
    
    
    var placesClient: GMSPlacesClient!
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var placesID: UILabel!
    @IBOutlet var placesCoordinates: UILabel!
    @IBOutlet var appleCoordinates: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var goldLabel: UILabel!
    @IBOutlet var placesType: UILabel!
    @IBOutlet var onLocationLabel: UILabel!
    @IBOutlet var placePhone: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var sleepDisableSwitch: UISwitch!
    @IBOutlet weak var debugInfoSwitch: UISwitch!
	@IBOutlet var notificationAccept: UIButton!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var notificationTemplate: UIImageView!
	@IBOutlet weak var notificationShadow: UIView!
	
	@IBOutlet weak var mapViewBG: UIView!
	@IBOutlet weak var bttfLabel: UILabel!
	@IBOutlet weak var earningSLabel: UILabel!
	var currentLocation = "non"
	var cachedLocation = "non"
    var gameTimer: Timer!
    var locationTimer: Timer!
    var atLocation = false
    var timeValue = 0
	struct GlobalVariable{
		static var goldValue = 1.00
	}

	var messageText = ""
	var buttonText = "OK"
    var goldStored = UserDefaults.standard.double(forKey: "ufZIU3TdbQ")
	var team = ""
	var firstRun = UserDefaults.standard.bool(forKey: "goldRushFirstRun")

    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations[0]
		print(String(describing: locations[0]))
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.001, 0.001)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated:true)
        self.appleCoordinates.text = "ACos: \(location.coordinate.latitude),\(location.coordinate.longitude)"
        if atLocation == false{timeValue = 0}
        self.onLocationLabel.text = String(atLocation)
		var coordModifierLat = 0.0001 * Double(arc4random_uniform(5) + 1)
		var coordModifierLon = 0.0001 * Double(arc4random_uniform(5) + 1)
		let negativeDecide = Double(arc4random_uniform(4))
		print(String(describing: negativeDecide))
		if negativeDecide == 1 {
			coordModifierLat *= -1
			coordModifierLon *= -1
		} else if negativeDecide == 2 {
			coordModifierLat *= -1
		} else if negativeDecide == 3{
			coordModifierLon *= -1
		}
		let newLat = myLocation.latitude + coordModifierLat
		let newLon = myLocation.longitude + coordModifierLon
		let goldPin = CLLocationCoordinate2DMake(newLat, newLon)
		print("ModifiersLat:" + String(describing: coordModifierLat))
		print("ModifiersLon:" + String(describing: coordModifierLon))
		print("NewLat:" + String(describing: newLat))
		print("NewLon:" + String(describing: newLon))
		var information = MKPointAnnotation()
		information.coordinate = goldPin
		information.title = "Gold Pin Dropped"
		information.subtitle = String(describing: newLat + newLon)
		//information.image = UIImage(named: "dot.png") //this is the line whats wrong
		//mapView.addAnnotation(information)
    }
    
    override func viewDidLoad() {
		if firstRun != false {
			let teamNum = arc4random_uniform(4) + 1
			if teamNum == 1{
				//team red
				
			} else if teamNum == 2 {
				//team green
			}else{
				//team blue
			}
		}
		
		
		if traitCollection.userInterfaceStyle == .light {
			print("Light mode")
		} else {
			print("Dark mode")
			mapViewBG.backgroundColor = UIColor.black
		}
        super.viewDidLoad()
      //  goldValue = goldStored
		
        placesClient = GMSPlacesClient.shared()
        self.getCurrentPlace()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    //    mapView.delegate = self
        configureTileOverlay()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: true)
        self.locationTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.runFindLocation), userInfo: nil, repeats: true)
		let user = Auth.auth().currentUser
		let db = Firestore.firestore()
		if let user = user {
			let email = user.email
			print(user.email!)
			let docRef = db.collection("users").document(email!)
			
			docRef.getDocument { (document, error) in
				if let document = document {
					print(String(describing: document.get("goldValue")))
					print(String(describing: document.data()))
					ViewController.GlobalVariable.goldValue = document.get("goldValue") as! Double
				} else {
					print("Document does not exist")
				}
			}
			
			
			
			
			
		}
		 goldLabel.text = String((ViewController.GlobalVariable.goldValue * 10).rounded() / 10)
		
		// Create a GMSCameraPosition that tells the map to display the
		// coordinate -33.86,151.20 at zoom level 6.
		// Creates a marker in the center of the map.

    }
    


	

	

	

		
	
	
	
	
	
	
	
	
    
    @IBAction func notificationAccept(_ sender: Any) {
		UIView.animate(withDuration: 0.3, animations: {
			self.notificationTemplate.alpha = 0
			self.notificationText.alpha = 0
			self.notificationAccept.alpha = 0
			self.notificationShadow.alpha = 0
		})
    }
	
	
	@IBAction func resetGold(_ sender: UIButton) {
		ViewController.GlobalVariable.goldValue = 1.00
		goldStored = 1.00
		UserDefaults.standard.set(Double(1.00), forKey: "ufZIU3TdbQ")
		messageText = "Gold has been reset."
		buttonText = "Awesome!"
		self.callNotification()
	}
	
	
    
    @IBAction func switchButtonChanged (sender: UISwitch) {
        if sleepDisableSwitch.isOn == true {
            UIApplication.shared.isIdleTimerDisabled = true
            print("No sleep")
            
        } else {
            UIApplication.shared.isIdleTimerDisabled = false
            print("auto sleep")
            
        }
    }
    
    
    
    
    @IBAction func debugSwitchButtonChanged (sender: UISwitch) {
        if debugInfoSwitch.isOn == true {
			bttfLabel.alpha = 0.2
			earningSLabel.alpha = 0.2
            addressLabel.alpha = 0.2
            placesID.alpha = 0.2
            placesCoordinates.alpha = 0.2
            appleCoordinates.alpha = 0.2
            timerLabel.alpha = 0.2
            placesType.alpha = 0.2
            onLocationLabel.alpha = 0.2
            placePhone.alpha = 0.2
            
        } else {
			bttfLabel.alpha = 0
			earningSLabel.alpha = 0
            addressLabel.alpha = 0
            placesID.alpha = 0
            placesCoordinates.alpha = 0
            appleCoordinates.alpha = 0
            timerLabel.alpha = 0
            placesType.alpha = 0
            onLocationLabel.alpha = 0
            placePhone.alpha = 0
        }
    }
    
    
    
    
    
    private func configureTileOverlay() {
        // We first need to have the path of the overlay configuration JSON
        guard let overlayFileURLString = Bundle.main.path(forResource: "overlay", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.add(tileOverlay)
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func getCurrentPlace(_ sender: AnyObject? = nil) {
        
		
		
		
		
	/*	let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
												  UInt(GMSPlaceField.placeID.rawValue))!
		placesClient?.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
		  (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
		  if let error = error {
			print("An error occurred: \(error.localizedDescription)")
			return
		  }

		  if let placeLikelihoodList = placeLikelihoodList {
			for likelihood in placeLikelihoodList {
			  let place = likelihood.place
			  print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
			  print("Current PlaceID \(String(describing: place.placeID))")
			}
		  }
		})*/
		
		
		
		
		
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "N/A"
            self.addressLabel.text = "N/A"
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    // print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    // print("Current Place address \(place.formattedAddress)")
                    self.placesID.text = ("ID: \(String(describing: place.placeID))")
                    self.placesCoordinates.text = ("PCo: \(place.coordinate.latitude),\(place.coordinate.longitude)")
                    self.placesType.text = String(describing: place.types)
					let user = Auth.auth().currentUser
					if let user = user {
						let email = user.email
						self.placePhone.text = email
					}
					
                  
                    //let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 6.0)
                    // let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    //self.view = mapView
                    //
                    // Creates a marker in the center of the map.
                    
                }
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                    if self.nameLabel.text == (place.formattedAddress?.components(separatedBy: ",")[0])
                    {
                        self.atLocation = false
                        self.timeValue = 0
                        self.timerLabel.text = "0"
                    } else {
                        self.atLocation = true
						self.currentLocation = place.name ?? "error no place name"
                    }
                  
                }
            }
        })
        
    }
    //END OF FUNC//
    
	
	
	
	
	@objc func runFindLocation(){
		
		self.getCurrentPlace()
		
	}
	

    
    @objc func runTimedCode(){

		
       // var goldValue = 1.00
        print("STORED:" + String(describing: goldStored))
        
        print(String(describing: ViewController.GlobalVariable.goldValue)) //1.0
        //goldValue = goldStored as! Double
     //   let doubleValue = o as! Double
        if goldStored == 0.0 {ViewController.GlobalVariable.goldValue=1.0
			goldStored = 1.0
		}
        
        
        if atLocation == true {
			earningSLabel.text = "true"

			if currentLocation == cachedLocation {
				earningSLabel.text = "true"

            timeValue += 1

            if timeValue >= 30 {
				
                ViewController.GlobalVariable.goldValue += 0.00666
				self.bttfLabel.text = String(ViewController.GlobalVariable.goldValue)
                goldLabel.text = String((ViewController.GlobalVariable.goldValue * 10).rounded() / 10)
                UserDefaults.standard.set(ViewController.GlobalVariable.goldValue, forKey: "ufZIU3TdbQ")
			
				
            }
            timerLabel.text = String(timeValue)
            
				
            
            
            
				
        goldLabel.text = String((ViewController.GlobalVariable.goldValue * 10).rounded() / 10)
			} else {
				timeValue=0
				earningSLabel.text = "false"

			}
		}
		cachedLocation = currentLocation

    }
    
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
	func callNotification(){
		self.notificationText.text = messageText
		notificationAccept.setTitle(buttonText, for: UIControlState.normal)
		UIView.animate(withDuration: 0.15, animations: {
			self.notificationTemplate.alpha = 1
			self.notificationText.alpha = 1
			self.notificationAccept.alpha = 1
			self.notificationShadow.alpha = 0.5
		})
		
		
	}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //END OF DOC/
}











