//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD
class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
      SVProgressHUD.show()
      Auth.auth().createUserAndRetrieveData(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { ( data, error) in
        if error != nil{
          print(error)
        }else
        {
          SVProgressHUD.dismiss()
          print("registration sucess !")
//         self.perform("goToChat", with: self)
          self.performSegue(withIdentifier: "goToChat", sender: self)

        }


      }


        
        
    } 
    
    
}
