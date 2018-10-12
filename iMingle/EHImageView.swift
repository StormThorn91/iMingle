//
//  EHImageView.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 11/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit

@IBDesignable
class EHImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    var cornerRadius: CGFloat = 1.0{
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }

}
