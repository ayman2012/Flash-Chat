//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
class ChatViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  , UITextFieldDelegate {





  // Declare instance variables here
var messageArray = [Message]()

  // We've pre-linked the IBOutlets
  @IBOutlet var heightConstraint: NSLayoutConstraint!
  @IBOutlet var sendButton: UIButton!
  @IBOutlet var messageTextfield: UITextField!
  @IBOutlet var messageTableView: UITableView!



  override func viewDidLoad() {
    super.viewDidLoad()

    //TODO: Set yourself as the delegate and datasource here:
    messageTableView.delegate = self
    messageTableView.dataSource = self
    messageTextfield.delegate = self
    configureTableView()

    //TODO: Set yourself as the delegate of the text field here:



    //TODO: Set the tapGesture here:
    let tabGesture = UITapGestureRecognizer(target: self, action: #selector (tabGestureclick))
    messageTableView.addGestureRecognizer(tabGesture)


    //TODO: Register your MessageCell.xib file here:
 messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
    retrievemessages()
    messageTableView.separatorStyle = .none

  }

  ///////////////////////////////////////////
  @objc func  tabGestureclick() {
    messageTextfield.endEditing(true)
  }
  //MARK: - TableView DataSource Methods

  func textFieldDidBeginEditing(_ textField: UITextField) {
    UIView.animate(withDuration: 0.5) {
      self.heightConstraint.constant = 315
      self.view.layoutIfNeeded()
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
     UIView.animate(withDuration: 0.5) {
      self.heightConstraint.constant = 50
      self.view.layoutIfNeeded()
    }
  }


  //TODO: Declare cellForRowAtIndexPath here:

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
    cell.messageBody.text = messageArray[indexPath.row].messageBody
    cell.senderUsername.text = messageArray[indexPath.row].title
    cell.avatarImageView.image = UIImage.init(named: "egg")
    if cell.senderUsername.text == Auth.auth().currentUser?.email as! String
    {
      cell.avatarImageView.backgroundColor = UIColor.flatMint()
cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
    }else
    {
      cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
      cell.messageBackground.backgroundColor = UIColor.flatGray()

    }
    return cell
  }

  //TODO: Declare numberOfRowsInSection here:
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
return messageArray.count
  }


  //TODO: Declare tableViewTapped here:



  //TODO: Declare configureTableView here:
 func configureTableView()
 {
  messageTableView.rowHeight = UITableViewAutomaticDimension
  messageTableView.estimatedRowHeight = 200
  }


  ///////////////////////////////////////////

  //MARK:- TextField Delegate Methods




  //TODO: Declare textFieldDidBeginEditing here:




  //TODO: Declare textFieldDidEndEditing here:



  ///////////////////////////////////////////


  //MARK: - Send & Recieve from Firebase





  @IBAction func sendPressed(_ sender: AnyObject) {


    //TODO: Send the message to Firebase and save it in our database

    messageTextfield.endEditing(true)
    messageTextfield.isEnabled = false
    sendButton.isEnabled = false

    let messagesDB = Database.database().reference().child("messages")
    let messageDic = ["Sender" : Auth.auth().currentUser?.email , "body": messageTextfield.text!]
    messagesDB.childByAutoId().setValue(messageDic){
      (error , ref) in
      if error != nil{
print(error)
      }else
      {
print("message send successfuly")
        self.messageTextfield.isEnabled = true
        self.sendButton.isEnabled = true
        self.messageTextfield.text! = ""
      }
    }


  }

  //TODO: Create the retrieveMessages method here:
func retrievemessages()
{
  let messageDB  = Database.database().reference().child("messages")
  messageDB.observe(.childAdded) { (snapshot) in

    let snapValue = snapshot.value as! Dictionary<String , String>
let text = snapValue["body"]!
let sender = snapValue["Sender"]!
    var newmessage  = Message()
    newmessage.messageBody = text
    newmessage.title = sender
    self.messageArray.append(newmessage)
    self.configureTableView()
    self.messageTableView.reloadData()
  }
  }





  @IBAction func logOutPressed(_ sender: AnyObject) {

    //TODO: Log out the user and send them back to WelcomeViewController
    do {
      try Auth.auth().signOut()
      navigationController?.popToRootViewController(animated: true)
    } catch {
      print("sign out error")
    }

  }



}
