//
//  HomeViewPTTableViewCell.swift
//  Mokhtabri
//
//  Created by Fatima ahmed on 06/01/2024.
//

import UIKit

class HomeViewPTTableViewCell: UITableViewCell {

    
    /* @IBOutlet weak var img: UIImageView!
     @IBOutlet weak var type: UILabel!
     @IBOutlet weak var price: UILabel!
     @IBOutlet weak var bookingDate: UILabel!
     @IBOutlet weak var hospitalName: UILabel!
     @IBOutlet weak var TestName: UILabel!*/
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var TestName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var hospitalName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
