//
//  ViewController.swift
//  Rolodex
//
//  Created by Austin Turner on 9/28/20.
//  Copyright © 2020 Austin Turner. All rights reserved.
//

import UIKit
import Contacts
import MessageUI


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [CNContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove extra separator lines
        self.tableView.tableFooterView = UIView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //loading on did appear instead of did load so that loading screen will init if loading takes too long
        self.loadContacts()
    }
    
    func loadContacts() {
        
        self.startLoading()
        
        let contactStore = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey, CNContactPostalAddressesKey, CNContactEmailAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName
        
        
        do {
            try contactStore.enumerateContacts(with: request) { [weak self]
                (contact, stop) in
                guard let strongSelf = self else {return}
                strongSelf.contacts.append(contact)
                strongSelf.tableView.reloadData()
                strongSelf.stopLoading()
            }
        }
        catch {
            self.stopLoading()
            self.showAlert(title: "Error", message: "An error occured trying to read your contacts")
            print("unable to fetch contacts")
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = self.contacts[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell

        let name = contact.givenName + " " + contact.familyName
        let addresses = contact.postalAddresses
        
        if contact.imageDataAvailable {
            cell.contactImageView.image = UIImage(data: contact.thumbnailImageData!)
        }
        else {
            cell.contactImageView.image = UIImage(named: "profile_icon")
        }
        
        cell.addresses = []
        for address in addresses {
            cell.addresses.append(address.value)
        }
        
        cell.nameLabel.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let phoneNumbers = self.contacts[indexPath.row].phoneNumbers
        let emails = self.contacts[indexPath.row].emailAddresses
        
        //allow user to access all phone numbers and emails within contact
        let actionController = UIAlertController(title: "Select An Option", message: "Please select your method of contact", preferredStyle: .actionSheet)
        
        for phoneNumber in phoneNumbers {
            let phoneText = phoneNumber.value.stringValue
            actionController.addAction(UIAlertAction(title: "Text: " + phoneText, style: UIAlertAction.Style.default) {
                                UIAlertAction in

                if (MFMessageComposeViewController.canSendText()) {
                    let controller = MFMessageComposeViewController()
                    controller.body = "Hey my Rolodex app really works!"
                    controller.recipients = [phoneText]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true, completion: nil)
                }
            })
        }
        
        for email in emails {
            let emailText = email.value as String
            
            actionController.addAction(UIAlertAction(title: "Email: " + emailText, style: UIAlertAction.Style.default) {
                                UIAlertAction in
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([emailText])
                    mail.setMessageBody("<p>Test email stuff goes here</p>", isHTML: true)

                    self.present(mail, animated: true)
                }
            })
        }
        
        actionController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
