//
//  SettingsViewController.swift
//  minertest
//
//  Created by nic on 3/4/18.
//  Copyright © 2018 test. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func signOutButton(_ sender: UIButton) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
		self.present(vc, animated: true, completion: nil)
	}
	
	@IBOutlet weak var resetGoldSettings: UIButton!
	@IBAction func resetGoldSettings(_ sender: Any) {
		ViewController.GlobalVariable.goldValue = 1.00
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
