//
//  LabBookingTableViewCell.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 10/12/2023.
//

import UIKit

class LabBookingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var bookingDate: UILabel!
    @IBOutlet weak var patient: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
