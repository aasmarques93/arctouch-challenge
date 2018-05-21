//
//  EnvironmentRequest.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Foundation

// MARK: - File Names -
struct FileName {
    static let requestLinks = "RequestLinks"
    static let environmentLink = "EnvironmentLinks"
}

// MARK: - Environment Base Enum -
enum EnvironmentBase: String {
    case heroku
    case theMovieDB
    case imagesTheMovieDB
    case reelgood
    case imagesReelgood
    case mock
}

// MARK: - Request Link Enum -
enum RequestUrl: String {
    case apiKey
    case authenticate
    case register
    case logout
    case savePersonalityTest
    case userPersonalityTest
    case profile
    case userWantToSeeMovies
    case saveWantToSeeMovie
    case deleteWantToSeeMovie
    case userSeenMovies
    case saveSeenMovie
    case deleteSeenMovie
    case personalityTest
    case personalityTestBR
    case personalityTypes
    case personalityTypesBR
    case nowPlaying
    case upcoming
    case topRated
    case popular
    case movie
    case videos
    case recommendations
    case similar
    case reviews
    case credits
    case searchMovie
    case searchPerson
    case searchByGenre
    case searchTV
    case genres
    case genresTV
    case person
    case personMovieCredits
    case personExternalIds
    case personImages
    case popularPeople
    case tvPopular
    case tvOnTheAir
    case tvTopRated
    case tvLatest
    case tvAiringToday
    case tvDetail
    case tvVideos
    case tvSimilar
    case tvRecommendations
    case tvCredits
    case tvImages
    case multiSearch
    case seasonDetail
    case netflixGenres
    case netflixGenresBR
    case netflixComing
    case netflixLeaving
    case netflixMoviesShow
    case netflixMovieShowDetail
    case netflixImage
    case roulette
}
