//
//  LabSelectTestTableViewCell.swift
//  Mokhtabri
//
//  Created by Ali Husain Ateya Ali Abdulrasool on 31/12/2023.
//

import UIKit

class LabSelectTestTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    func update(with test: Test) {
        lblName.text = test.name

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
    
     

}
