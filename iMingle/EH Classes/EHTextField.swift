//
//  EHTextField.swift
//  iMingle
//
//  Created by Justine Paul Sanchez Vitan on 07/10/2018.
//  Copyright © 2018 CGJ. All rights reserved.
//

import UIKit

@IBDesignable
class EHTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius;
        }
    }
    
    @IBInspectable
    public var leftPadding: CGFloat = 1.0 {
        didSet{
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
            self.leftViewMode = .always
        }
    }
}
