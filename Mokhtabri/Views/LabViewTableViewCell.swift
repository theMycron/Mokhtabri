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
    
    func update(with facility: MedicalService) {
        lblName.text = facility.name
        lblPrice.text = "\(facility.price)"
        lblDescription.text = facility.description
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
