//
//  MainTableViewCell.swift
//  GlobalLogic
//
//  Created by Gerardo Villarroel on 22-06-22.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    //Controles
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
