//
//  NSConstraint+DSL.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import UIKit

@resultBuilder
class NSConstraintBuilder {
    static func buildBlock(_ constraints: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
        constraints.flatMap { $0 }
    }
    
    static func buildExpression(_ constraint: NSLayoutConstraint) -> [NSLayoutConstraint] {
        return [constraint]
    }
    
    static func buildEither(first constraint: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return constraint
    }
    
    static func buildEither(second constraint: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        return constraint
    }
}

extension NSLayoutConstraint {
    static func activate(@NSConstraintBuilder _ constraints: () -> [NSLayoutConstraint]) {
        constraints().forEach { $0.isActive = true }
    }
}
