//
//  EHView.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 07/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit

@IBDesignable
class EHView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    public var cornerRadius: CGFloat = 1.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
