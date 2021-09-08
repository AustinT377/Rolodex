//
//  Extensions.swift
//  Rolodex
//
//  Created by Austin Turner on 9/29/20.
//  Copyright © 2020 Austin Turner. All rights reserved.
//

//extensions in a separate file because they seem to pile up as projects get bigger

import UIKit


extension UIViewController {
    func startLoading(message: String = "Loading") {
        self.view.isUserInteractionEnabled = false
        LoadingIndicatorView.show(self.view, loadingText: message)
    }
    
    @objc func stopLoading() {
        self.view.isUserInteractionEnabled = true
        LoadingIndicatorView.hide()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
