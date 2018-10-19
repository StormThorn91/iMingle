//
//  SearchForPeopleTableViewCell.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 16/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit

class SearchForPeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfilePicture: EHImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelExtraInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(name: String, extraInformation: String){
        labelName.text = name
        labelExtraInformation.text = extraInformation
    }

}
