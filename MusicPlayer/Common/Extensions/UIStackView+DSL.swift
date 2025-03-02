//
//  UIStackView+DSL.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 02/03/25.
//

import Foundation
import UIKit

@resultBuilder
struct StackViewArrangeBuilder {
    static func buildBlock(_ views: [UIView]...) -> [UIView] {
        views.flatMap { $0 }
    }
    
    static func buildExpression(_ view: UIView) -> [UIView] {
        return [view]
    }
}

extension UIStackView {
    func addArrangedSubViewDSL(@StackViewArrangeBuilder _ v: () -> [UIView]) -> UIStackView {
        v().forEach { view in
            addArrangedSubview(view)
        }
        return self
    }
}
