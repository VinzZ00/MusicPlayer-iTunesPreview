//
//  MusicPanelView.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 02/03/25.
//

import UIKit
import Kingfisher

protocol MusicPanelDelegate {
    func onTapPlayPause()
    func onTapNext()
    func onTapRewind()
}

class MusicPanelView: UIView {

    var musicImageView: UIImageView = {
        var imgV = UIImageView(image: UIImage(systemName: "music.note"))
        imgV.tintColor = .gray
        imgV.backgroundColor = .lightGray
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    var slider: UISlider = UISlider()
    let playerWrapper: UIView = UIView()
    let playOrPauseButton: UIButton = UIButton()
    let nextButton: UIButton = UIButton()
    let rewindButton: UIButton = UIButton()
    private var delegate: MusicPanelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewConfig()
        setupHierarchy()
        setupConstraint()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewConfig() {
        backgroundColor = .gray.withAlphaComponent(0.5)
        layer.cornerRadius = 10
    }
    
    private func setupHierarchy() {
        autoLayoutSubViews {
            musicImageView
            slider
            playerWrapper.autoLayoutSubViews {
                rewindButton
                playOrPauseButton
                nextButton
            }
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate {
            musicImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
            musicImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8)
            musicImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
            musicImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2)
            musicImageView.heightAnchor.constraint(equalTo: musicImageView.widthAnchor)
            
            slider.topAnchor.constraint(equalTo: musicImageView.topAnchor)
            slider.leadingAnchor.constraint(equalTo: musicImageView.trailingAnchor, constant: 8)
            slider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
            
            playerWrapper.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8)
            playerWrapper.leadingAnchor.constraint(equalTo: slider.leadingAnchor)
            playerWrapper.trailingAnchor.constraint(equalTo: slider.trailingAnchor)
            playerWrapper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
            
            rewindButton.leadingAnchor.constraint(equalTo: playerWrapper.leadingAnchor, constant: 8)
            rewindButton.centerYAnchor.constraint(equalTo: playerWrapper.centerYAnchor)
            rewindButton.widthAnchor.constraint(equalTo: playerWrapper.widthAnchor, multiplier: 0.2)
            rewindButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor)
            
            playOrPauseButton.centerXAnchor.constraint(equalTo: playerWrapper.centerXAnchor)
            playOrPauseButton.centerYAnchor.constraint(equalTo: playerWrapper.centerYAnchor)
            playOrPauseButton.widthAnchor.constraint(equalTo: playerWrapper.widthAnchor, multiplier: 0.2)
            playOrPauseButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor)
            
            nextButton.trailingAnchor.constraint(equalTo: playerWrapper.trailingAnchor, constant:  -8)
            nextButton.centerYAnchor.constraint(equalTo: playerWrapper.centerYAnchor)
            nextButton.widthAnchor.constraint(equalTo: playerWrapper.widthAnchor, multiplier: 0.2)
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor)
        }
    }
    
    private func setupStyle() {
        musicImageView.contentMode = .scaleAspectFit
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = .lightGray
        
        rewindButton.contentMode = .scaleAspectFit
        playOrPauseButton.contentMode = .scaleAspectFit
        nextButton.contentMode = .scaleAspectFit
        
        buttonConfig(rewindButton, UIImage(systemName: "backward.fill"))
        buttonConfig(playOrPauseButton, UIImage(systemName: "pause.fill"))
        buttonConfig(nextButton, UIImage(systemName: "forward.fill"))
    }
    
    private func buttonConfig(_ button : UIButton, _ image: UIImage?) {
        button.setImage(image, for: .normal)
        button.tintColor = .musicPlayerButtonBackground
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
    }
    
    func setThumbnailImage(imageUrl: String) {
        musicImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(systemName: "music.note"))
    }
    
    func setPlayOrPauseImage(isPlaying: Bool) {
        playOrPauseButton.setImage(!isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func setSliderValue(value: Float) {
        slider.value = value
    }
    
    func setDelegate(delegate: MusicPanelDelegate) {
        self.delegate = delegate
    }
    
    @objc func buttonAction(sender: UIButton) {
        switch sender {
        case rewindButton:
            delegate?.onTapRewind()
        case playOrPauseButton:
            delegate?.onTapPlayPause()
        case nextButton:
            delegate?.onTapNext()
        default:
            break
        }
    }
}
