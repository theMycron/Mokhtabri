//
//  Alerts.swift
//  Mokhtabri
//
//  Created by Nooni on 12/12/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func confirmation(title:String, message:String, confirmHandler: @escaping () -> Void){
        let alert = UIAlertController(title:title,message:message,preferredStyle: .alert)
        let confirm = UIAlertAction(title:"Yes", style: .default){ action in
            confirmHandler()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirm)
        alert.addAction(cancel)
        present(alert,animated: true)
    }
    
    func logoutAlert() {
        confirmation(title: "Confirm Log Out", message: "Are you sure you would like to log out?", confirmHandler: {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "login")
            self.view.window?.rootViewController = viewController
            self.view.window?.makeKeyAndVisible()
        })
    }
    
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        alert.addAction(dismissAction)
        present(alert, animated: true)
    }

}
