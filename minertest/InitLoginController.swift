//
//  InitLoginController.swift
//  minertest
//
//  Created by nic on 3/4/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI



class InitLoginController: UIViewController, FUIAuthDelegate{
	fileprivate(set) var auth:Auth?
	fileprivate(set) var authUI: FUIAuth? //only set internally but get externally
	fileprivate(set) var authStateListenerHandle: AuthStateDidChangeListenerHandle?
	@IBOutlet weak var emailInput: UITextField!
	@IBOutlet weak var passwordInput: UITextField!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var verificationStatus: UILabel!
	@IBOutlet weak var signOutButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.auth = Auth.auth()
		let cachedEmail = UserDefaults.standard.string(forKey: "authEmailCache")
		let cachedPass = UserDefaults.standard.string(forKey: "authPassCache")
		if cachedEmail != nil {
			Auth.auth().signIn(withEmail: cachedEmail!, password: cachedPass!) { (user, error) in
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
				self.present(vc, animated: true, completion: nil)
		print(String(describing: cachedEmail));
				print(String(describing: cachedPass));
			}
		}
	}
	
	
	@IBAction func signOutButton(_ sender: Any) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
			self.verificationStatus.text = "Error: " + String(describing: signOutError)
			return
		}
		self.verificationStatus.text = "Signed out"
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	
	
	
	
	@IBAction func signUpButton(_ sender: Any) {
		Auth.auth().createUser(withEmail: self.emailInput.text!, password: self.passwordInput.text!) { (user, error) in
			Auth.auth().signIn(withEmail: self.emailInput.text!, password: self.passwordInput.text!) { (user, error) in
				UserDefaults.standard.set(self.emailInput.text!, forKey: "authEmailCache")
				UserDefaults.standard.set(self.passwordInput.text!, forKey: "authPassCache")
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
				self.present(vc, animated: true, completion: nil)
			}
		}
		
	}
	
	

	
	
}
