//
//  AppDelegate.swift
//  Rolodex
//
//  Created by Austin Turner on 9/28/20.
//  Copyright © 2020 Austin Turner. All rights reserved.
//

import UIKit
import Contacts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //get user permissions
        self.checkPermissionsContacts()
        self.checkPermissionsLocation()
        
        return true
    }
    
    //check permissions for contacts
    func checkPermissionsContacts() {
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
            if !access {
                let alertController = UIAlertController(title: "Hmmmm", message: "We kind of need your conacts for this app. Please update permissions in yor settings", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                })
                
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
                
                
                DispatchQueue.main.async {
                    let window = UIApplication.shared.keyWindow
                    window?.rootViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }

    //check permissions for location services
    func checkPermissionsLocation() {
        LocationManager.shared.requestLocation()
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
