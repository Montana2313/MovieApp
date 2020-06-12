//
//  People.swift
//  MovieApp
//
//  Created by Mac on 30.05.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation

struct People: Codable {
    let birthday, knownForDepartment, deathday: String?
    let id: Int
    let name: String?
    let alsoKnownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool?
    let imdbID: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
    }
}
// MARK: - Peoples
struct Peoples: Codable {
    let page, totalResults, totalPages: Int?
    let results: [Result]?

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Codable {
    let popularity: Double?
    let knownForDepartment: KnownForDepartment?
    let name: String?
    let id: Int?
    let profilePath: String?
    let adult: Bool?
    let knownFor: [KnownFor]?
    let gender: Int?

    enum CodingKeys: String, CodingKey {
        case popularity
        case knownForDepartment = "known_for_department"
        case name, id
        case profilePath = "profile_path"
        case adult
        case knownFor = "known_for"
        case gender
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let originalName: String?
    let genreIDS: [Int]?
    let mediaType: MediaType?
    let name: String?
    let originCountry: [String]?
    let voteCount: Int?
    let firstAirDate: String?
    let backdropPath: String?
    let originalLanguage: OriginalLanguage?
    let id: Int
    let voteAverage: Double?
    let overview, posterPath: String?
    let releaseDate: String?
    let video: Bool?
    let title, originalTitle: String?
    let adult: Bool?

    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case genreIDS = "genre_ids"
        case mediaType = "media_type"
        case name
        case originCountry = "origin_country"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case id
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case video, title
        case originalTitle = "original_title"
        case adult
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case th = "th"
    case zh = "zh"
}

enum KnownForDepartment: String, Codable {
    case acting = "Acting"
}
// MARK: - PeopleImages
struct PeopleImages: Codable {
    let profiles: [Profile]?
    let id: Int
}

// MARK: - Profile
struct Profile: Codable {
    let width, height, voteCount, voteAverage: Int?
    let filePath: String?
    let aspectRatio: Double?

    enum CodingKeys: String, CodingKey {
        case width, height
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case filePath = "file_path"
        case aspectRatio = "aspect_ratio"
    }
}
enum PeopleEnum{
    case PeopleDetail
    case LatestPeople
    case PopularPeoples
    case PeopleImages
}
