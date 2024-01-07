//
//  PatientHospitalViewTableViewCell.swift
//  Mokhtabri
//
//  Created by Fatema Ahmed Ebrahim Mohamed Naser on 14/12/2023.
//
import UIKit

class PatientHospitalViewTableViewCell: UITableViewCell {

    // declare elements
    
    @IBOutlet weak var HospitalName: UILabel!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var openingTime: UILabel!
    @IBOutlet weak var location: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
