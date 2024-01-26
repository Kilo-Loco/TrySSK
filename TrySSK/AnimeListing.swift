//
//  AnimeListing.swift
//  TrySSK
//
//  Created by Kilo Loco on 1/25/24.
//

import Foundation

public struct AnimeListing: Embeddable, Identifiable {
    public let id: String
    public let name: String
    public let englishName: String
    public let genres: String
    public let synopsis: String
    
    public var embeddingText: String { name }
    
    public var metadata: [String: String] {
        ["englishName": englishName, "genres": genres, "synopsis": synopsis]
    }
}

extension AnimeListing: CSVDecodable {
    public init?(dict: [String: String]) {
        guard
            let id = dict["anime_id"],
            let name = dict["Name"],
            let englishName = dict["English name"],
            let genres = dict["Genres"],
            let synopsis = dict["Synopsis"]
        else { return nil }
        self.id = id
        self.name = name
        self.englishName = englishName
        self.genres = genres
        self.synopsis = synopsis
    }
}

public final class AnimeListingCache {
    public var cache: [String: AnimeListing] = [:]
    
    public func cache(_ animes: [AnimeListing]) {
        for anime in animes {
            cache[anime.id] = anime
        }
    }
    
    public func getCachedAnimes() -> [AnimeListing] {
        Array(cache.values)
    }
}
