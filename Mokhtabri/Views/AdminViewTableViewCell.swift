//
//  AdminViewTableViewCell.swift
//  Mokhtabri
//
//  Created by Yousif Mohamed Ali Abdulla Salman Alhawaj on 04/12/2023.
//

import UIKit
import Kingfisher

class AdminViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    
    @IBOutlet weak var imgDisplay: UIImageView!
    
    func update(with facility: MedicalFacility) {
        lblName.text = facility.name
        lblCity.text = facility.city
        lblType.text = facility.type.rawValue
        // add image using KingFisher library
        displayImage(facility: facility)
    }
    
    func displayImage(facility: MedicalFacility) {
        imgDisplay.kf.indicatorType = .activity
        // downsample image to save resources
        let size: CGSize = CGSize(width: imgDisplay.bounds.size.width*2 , height: imgDisplay.bounds.size.height*2)
        let processor: ImageProcessor = DownsamplingImageProcessor(size: size)
        if (facility.imageDownloadURL != nil) {
            imgDisplay.kf.setImage(with: facility.imageDownloadURL, options: [.processor(processor), .cacheOriginalImage])
        } else {
            // if facility has no image, set a default image
            imgDisplay.kf.setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/fir-testing-512eb.appspot.com/o/testImages%2F504276.png?alt=media&token=cb30478e-345b-4de7-b2bd-aecdb7e7765d"), options: [.processor(processor)])
        }
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
