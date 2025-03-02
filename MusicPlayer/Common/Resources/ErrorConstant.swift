//
//  ErrorConstant.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation

extension NSError {
    static let invalidUrl = NSError(domain: "Invalid URL", code: 1, userInfo: nil)
    static let invalidData = NSError(domain: "Invalid Data", code: 4, userInfo: nil)
}
