//
//  CustomTextField.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 02/03/25.
//

import UIKit

class CustomTextField: UITextField {

    var padding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }


}
