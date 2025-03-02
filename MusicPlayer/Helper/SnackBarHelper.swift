//
//  SnackBarHelper.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import UIKit

class SnackbarView: UIView {
    private let messageLabel = UILabel()

    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String) {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        layer.cornerRadius = 8
        clipsToBounds = true

        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func show(in view: UIView, duration: TimeInterval = 3.0) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 80)
        ])
        
        // Slide in animation
        transform = CGAffineTransform(translationX: 0, y: 50)
        alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.transform = .identity
        })
        
        // Auto-dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.dismiss()
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: 50)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

extension UIViewController {
    func showSnackbar(message: String, duration: TimeInterval = 3.0) {
        let snackbar = SnackbarView(message: message)
        snackbar.show(in: self.view, duration: duration)
    }
}
