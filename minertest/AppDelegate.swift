//
//  AppDelegate.swift
//  minertest
//
//  Created by nic on 2/25/18.
//  Copyright © 2018 test. All rights reserved.
//
//AIzaSyBC108Vy4VENRkbAelPabX1jv6N7_W4nVM

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
      
        //change
        //let defaults = UserDefaults.standard
        //defaults.set(goldValue, forKey: "0aef58sj129")
        
        //read
        //let defaults = UserDeafults.standard
        //let goldValue = defaults.string(forKey: "0aef58sj129")
        
        FirebaseApp.configure()
        let db = Firestore.firestore()
		

        GMSServices.provideAPIKey("AIzaSyDJ0HdUaKvWm7hZOkdr_Y1RLXI_04Vbwbc")
        GMSPlacesClient.provideAPIKey("AIzaSyBC108Vy4VENRkbAelPabX1jv6N7_W4nVM")
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
		let user = Auth.auth().currentUser
		let db = Firestore.firestore()
		if let user = user {
			let email = user.email
			db.collection("userGoldValues").document(email!).setData([
				"email": email,
				"goldValue": ViewController.GlobalVariable.goldValue
			]) { err in
				if let err = err {
					print("Error writing document: \(err)")
				} else {
					print("Document successfully written!")
				}
			}
		}
		UserDefaults.standard.setValue(false, forKey: "goldRushFirstRun")
}
	



    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

	func applicationWillTerminate(_ application: UIApplication) {
		


}
}
