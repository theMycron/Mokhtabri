//
//  HospitalDetailsPrototypeTableViewCell.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 07/01/2024.
//

import UIKit

class HospitalDetailsPrototypeTableViewCell: UITableViewCell {
    
    /* @IBOutlet weak var img: UIImageView!
     @IBOutlet weak var type: UILabel!
     @IBOutlet weak var price: UILabel!
     @IBOutlet weak var bookingDate: UILabel!
     @IBOutlet weak var hospitalName: UILabel!
     @IBOutlet weak var TestName: UILabel!*/
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var TestName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
