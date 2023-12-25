//
//  LabViewTableViewCell.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 25/12/2023.
//

import UIKit

class LabViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    func update(with service: MedicalService) {
        lblName.text = service.name
        lblPrice.text = "\(service.price)"
        lblDescription.text = service.serviceDescription
        // TODO: add image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
