//
//  ColorConstant.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import UIKit

extension UIColor {
    static let headerBackground: UIColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#1A1A1A") : UIColor(hex: "#F0F0F0")
    }
    
    static let searchBarBackground: UIColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#333333") : UIColor(hex: "#EBEAEA")
    }
    
    static let musicPlayerButtonBackground: UIColor = .black
    
    static let sliderTint: UIColor = .lightGray
}
