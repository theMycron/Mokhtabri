//
//  PatientBookingTableViewCell.swift
//  Mokhtabri
//
//  Created by Noora Qasim on 17/12/2023.
//

import UIKit
import Kingfisher
import FirebaseStorage

class PatientBookingTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bookingDate: UILabel!
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
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView?.kf.cancelDownloadTask()  // Cancel the download task
        self.imageView?.image = nil  // Reset the image to nil or a placeholder
    }

    
    
  

}
