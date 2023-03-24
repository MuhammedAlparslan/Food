//
//  RestoranNameViewCell.swift
//  Food
//
//  Created by Alparslan Cafer on 16.03.2023.
//

import UIKit

class RestoranNameViewCell: UITableViewCell {
    @IBOutlet weak var restoranNameImage: UIImageView!
    @IBOutlet weak var restoranNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
