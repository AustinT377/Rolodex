//
//  ContactTableViewCell.swift
//  Rolodex
//
//  Created by Austin Turner on 9/28/20.
//  Copyright © 2020 Austin Turner. All rights reserved.
//

import UIKit
import Contacts

class ContactTableViewCell: UITableViewCell {
    
    var addresses: [CNPostalAddress] = [] {
        //update address any time a new address is added or removed
        didSet {
            self.addressUpdated()
        }
    }
        
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //remove any extra separater lines
        self.tableView.tableFooterView = UIView()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func addressUpdated() {
        tableView.reloadData()
        //if no addresses dont make room for them
        tableViewHeightConstraint.constant = (tableView.contentSize.height > 0) ? tableView.contentSize.height + 20 : 0
    }

}



extension ContactTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let address = self.addresses[indexPath.row]
        let addressText = address.street + ", " + address.city + " " + address.state + " " + address.postalCode
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        cell.textLabel?.text = addressText
        cell.detailTextLabel?.text = "--"

        //loading location services in separate file
        LocationManager.shared.getDistance(address: addressText) { (distance) in
            if distance != nil {
                cell.detailTextLabel?.text = "\(distance!) mi"
            }
            else {
                cell.detailTextLabel?.text = "NA"
            }
        }
                        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //deselect row so it doesnt look stuck
        tableView.deselectRow(at: indexPath, animated: false)

    }
    
    
}
