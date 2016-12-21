//
//  ViewController.swift
//  uploadFiles
//
//  Created by admin on 12/20/16.
//  Copyright © 2016 solu4b. All rights reserved.
//

import UIKit
import Kinvey
import KeychainAccess

class ViewController: UIViewController {

    var keychain: Keychain!
    
    @IBOutlet weak var userTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keychain = Keychain()
        //        keychain[userTextfield.text!] = passTextfield.text
        
        let user = try? keychain.get("username")
        let pass = try? keychain.get("password")
        
        if let user = user,
            let pass = pass {
            userTextfield.text = user
            passTextfield.text = pass
        }

    }
    
    @IBAction func login(_ sender: Any) {
        
        guard let user = userTextfield.text,
            let pass = passTextfield.text,
            user.characters.count > 0, pass.characters.count > 0 else {
                let alert = UIAlertController(title: "Faltan datos", message: "Favor complete nombre de usuario y/o contraseña.", preferredStyle: .alert)
                
                present(alert, animated: true, completion: nil)
                return
        }
        
        do {
            try keychain.set(user, key: "username")
            try keychain.set(pass, key: "password")
        }
        catch let error {
            print(error)
        }
        
        User.login(username: user, password: pass) { user, error in
            if let user = user {
                //the log-in was successful and the user is now the active user and credentials saved
                //hide log-in view and show main app content
                print("User: \(user)")
                
                self.completeLogin()
            } else if let error = error as? NSError {
                //there was an error with the update save
                let message = error.localizedDescription
                let alert = UIAlertController(
                    title: NSLocalizedString("Create account failed", comment: "Sign account failed"),
                    message: message,
                    preferredStyle: .alert
                )
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func completeLogin(){
        let searchFileVC = storyboard?.instantiateViewController(withIdentifier: "SearchFileViewController") as! SearchFileViewController
        
        present(searchFileVC, animated: true, completion: nil)
    }
    

}

