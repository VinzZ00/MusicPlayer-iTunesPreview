//
//  UIView+DSLStyle.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 28/02/25.
//
import UIKit

@resultBuilder
struct AutoLayoutBuilder {
    static func buildBlock(_ views: [UIView]...) -> [UIView] {
        views.flatMap { $0 }
    }
    
    static func buildExpression(_ view: UIView) -> [UIView] {
        return [view]
    }
}

extension UIView {
    @discardableResult
    func autoLayoutSubViews(@AutoLayoutBuilder _ v: () -> [UIView]) -> UIView{
        v().forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        return self
    }
}

