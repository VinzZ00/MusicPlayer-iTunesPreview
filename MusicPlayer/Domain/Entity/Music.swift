//
//  Music.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation

struct Music {
    let previewUrl: String?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artWorkUrl: String?
    
    init(previewUrl: String?, trackName: String?, artistName: String?, collectionName: String?, artWorkUrl: String?) {
        self.previewUrl = previewUrl
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.artWorkUrl = artWorkUrl
    }
    
    init(from dto: MusicDTO) {
        self.previewUrl = dto.previewUrl
        self.trackName = dto.trackName
        self.artistName = dto.artistName
        self.collectionName = dto.collectionName
        self.artWorkUrl = dto.artWorkUrl
    }
}
