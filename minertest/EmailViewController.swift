//
//  EmailViewController.swift
//  minertest
//
//  Created by nic on 3/4/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebasePhoneAuthUI
import FBSDKCoreKit
import FBSDKLoginKit




class EmailViewController: UIViewController, FUIAuthDelegate  {
//	@IBOutlet weak var passwordInput: UITextField!
	
	@IBOutlet weak var submitAuthentication: UIButton!
//	@IBOutlet weak var emailInput: UITextField!
	
	fileprivate(set) var auth:Auth?
	fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
	fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?


	
    override func viewDidLoad() {
        super.viewDidLoad()
		
			// ...
		}
	
	@IBAction func submitAuthentication(_ sender: Any) {
		Auth.auth().createUser(withEmail: "niccarlsonx@gmail.com", password: "qe5u7.s15.0") { (user, error) in
		}
	//	let authUI = FUIAuth.defaultAuthUI()
		// You need to adopt a FUIAuthDelegate protocol to receive callback
	//	let phoneProvider = FUIPhoneAuth.init(authUI: FUIAuth.defaultAuthUI()!)
	//	authUI?.delegate = self
	//	FUIAuth.defaultAuthUI()?.providers = [phoneProvider]

    }





}
