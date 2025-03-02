//
//  SearchView.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 28/02/25.
//

import UIKit
import Kingfisher

class MusicCell: UITableViewCell {
    private let musicImage: UIImageView = UIImageView()
    private let musicTitle: UILabel = UILabel()
    private let artistLabel: UILabel = UILabel()
    private let albumLabel: UILabel = UILabel()
    private let playingSymbol: UIImageView = UIImageView()
    
    static let identifier = "MusicCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraint()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        contentView.autoLayoutSubViews {
            musicImage
            musicTitle
            artistLabel
            albumLabel
            playingSymbol
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate {
            musicImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            musicImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16)
            musicImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            musicImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2)
            musicImage.heightAnchor.constraint(equalTo: musicImage.widthAnchor)
            
            musicTitle.topAnchor.constraint(equalTo: musicImage.topAnchor)
            musicTitle.leadingAnchor.constraint(equalTo: musicImage
                .trailingAnchor, constant: 8)
            musicTitle.bottomAnchor.constraint(equalTo: artistLabel.topAnchor, constant: -8)

            artistLabel.centerYAnchor.constraint(equalTo: musicImage.centerYAnchor)
            artistLabel.leadingAnchor.constraint(equalTo: musicImage.trailingAnchor, constant: 8)

            albumLabel.bottomAnchor.constraint(equalTo: musicImage.bottomAnchor)
            albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8)
            albumLabel.leadingAnchor.constraint(equalTo: musicImage.trailingAnchor, constant: 8)

            playingSymbol.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            playingSymbol.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            playingSymbol.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
            playingSymbol.widthAnchor.constraint(equalTo: playingSymbol.heightAnchor)

            albumLabel.trailingAnchor.constraint(equalTo: playingSymbol.leadingAnchor, constant: -8)
            artistLabel.trailingAnchor.constraint(equalTo: playingSymbol.leadingAnchor, constant: -8)
            musicTitle.trailingAnchor.constraint(equalTo: playingSymbol.leadingAnchor, constant: -8)
            
        }
    }
    
    private func setupStyle() {
        playingSymbol.image = UIImage(systemName: "waveform")
        playingSymbol.contentMode = .scaleAspectFit
        musicImage.contentMode = .scaleAspectFit
        
        musicTitle.numberOfLines = 1
        artistLabel.numberOfLines = 1
        albumLabel.numberOfLines = 1
        
        playingSymbol.isHidden = true
        
        musicImage.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        musicImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        playingSymbol.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        playingSymbol.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func setupData(song: Music) {
        musicTitle.text = song.trackName
        artistLabel.text = song.artistName
        albumLabel.text = song.collectionName
        musicImage.kf.setImage(with: URL(string: song.artWorkUrl ?? ""), placeholder: UIImage(systemName: "music.note"))
    }
    
    func setPlayingState(isPlaying: Bool) {
        playingSymbol.isHidden = !isPlaying
    }
}
