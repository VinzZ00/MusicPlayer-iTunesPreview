//
//  LoadingManager.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 06/03/25.
//

import Foundation
import UIKit

class LoadingViewHelper: UIView {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        return indicator
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private var isLoading: Bool = false
    var parentBg = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        autoLayoutSubViews{
            backgroundView.autoLayoutSubViews {
                activityIndicator
            }
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate {
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor)
            backgroundView.widthAnchor.constraint(equalToConstant: 80)
            backgroundView.heightAnchor.constraint(equalToConstant: 80)
            
            activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
            activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        }
    }
    
    func show(in view: UIView, isDismissable: Bool = false) {
        if !isLoading  {
            isLoading = true
            frame = view.bounds
    
            parentBg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            view.autoLayoutSubViews {
                parentBg
                self
            }
            
            NSLayoutConstraint.activate {
                parentBg.leadingAnchor.constraint(equalTo: view.leadingAnchor)
                parentBg.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                parentBg.topAnchor.constraint(equalTo: view.topAnchor)
                parentBg.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                
                self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            }
            
            if isDismissable {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
                addGestureRecognizer(tapGesture)
            }
            activityIndicator.startAnimating()
        }
    }
    
    @objc private func dismiss() {
        hide()
    }
    
    func hide() {
        isLoading = false
        activityIndicator.stopAnimating()
        parentBg.removeFromSuperview()
        removeFromSuperview()
    }
}

