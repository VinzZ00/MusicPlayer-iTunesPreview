//
//  MusicDTO.swift
//  MusicPlayer
//
//  Created by Elvin Sestomi on 01/03/25.
//

import Foundation

struct MusicListDTO: Codable {
    let results: [MusicDTO]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct MusicDTO: Codable {
    let previewUrl: String?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artWorkUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case previewUrl = "previewUrl"
        case trackName = "trackName"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case artWorkUrl = "artworkUrl60"
    }
}
