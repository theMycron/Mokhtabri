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
}
