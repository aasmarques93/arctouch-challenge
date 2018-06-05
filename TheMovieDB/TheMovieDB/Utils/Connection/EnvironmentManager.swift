//
//  EnvironmentManager.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import Moya

// MARK: - Environment Base Enum -
enum EnvironmentBase: String {
    case heroku
    case theMovieDB
    case imagesTheMovieDB
    case reelgood
    case imagesReelgood
    case custom
    case mock
    
    var path: String {
        return FileManager.load(file: .environmentLink, key: rawValue)
    }
}

struct RequestBase {
    var requestUrl: RequestUrl?
    var environmentBase: EnvironmentBase
    var customPath: String?
    var moyaMethod: Moya.Method
    var urlParameters: [String: Any]?
    var parameters: [String: Any]?
    var data: Data
    var requestHeaders: [String: String]?
    
    init(requestUrl: RequestUrl? = nil,
         environmentBase: EnvironmentBase,
         customPath: String? = nil,
         method: Moya.Method,
         urlParameters: [String: Any]? = nil,
         parameters: [String: Any]? = nil,
         sampleData: Data = Data(),
         headers: [String: String]? = nil) {
        
        self.requestUrl = requestUrl
        self.environmentBase = environmentBase
        self.customPath = customPath
        self.moyaMethod = method
        self.urlParameters = urlParameters
        self.parameters = parameters
        self.data = sampleData
        self.requestHeaders = headers
    }
}

extension RequestBase: TargetType {
    var baseURL: URL {
        return URL(string: environmentBase.path) ?? URL(string: "")!
    }
    var path: String {
        guard let customPath = customPath else {
            return requestUrl?.url(environmentBase: environmentBase, parameters: urlParameters) ?? ""
        }
        return customPath
    }
    var method: Moya.Method {
        return moyaMethod
    }
    var sampleData: Data {
        return data
    }
    var task: Task {
        guard method == .post, let parameters = parameters else {
            return .requestPlain
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    var headers: [String: String]? {
        return requestHeaders
    }
}

// MARK: - Request Link Enum -
enum RequestUrl: String {
    // MARK: - Heroku
    
    case authenticate
    case register
    case logout
    case savePersonalityTest
    case userPersonalityTest
    case profile
    case profileByFacebookId
    case userWantToSeeMovies
    case saveWantToSeeMovie
    case deleteWantToSeeMovie
    case userSeenMovies
    case saveSeenMovie
    case deleteSeenMovie
    case trackShow
    case userShowsTrack
    case rate
    case userRatings
    case userFriendsProfiles
    case personalityTest
    case personalityTestBR
    case personalityTypes
    case personalityTypesBR
    
    // MARK: - The Movie DB
    
    case apiKey
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
    case latest
    case searchMovie
    case searchPerson
    case searchByGenre
    case searchImage
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
    
    // MARK: - Reelgood
    
    case netflixGenres
    case netflixGenresBR
    case netflixComing
    case netflixLeaving
    case netflixMoviesShow
    case netflixMovieShowDetail
    case netflixImage
    case roulette
}

extension RequestUrl {
    func url(environmentBase: EnvironmentBase, parameters: [String: Any]? = nil) -> String {
        var link = ""
        guard let parameters = parameters else {
            link += path
            return environmentBase == .theMovieDB ? link + apiKey : link
        }
        
        link += createUrl(from: path, environmentBase: environmentBase, parameters: parameters)
        return link
    }
    
    var path: String {
        return FileManager.load(file: .requestLinks, key: rawValue)
    }
    
    func createUrl(from string: String, environmentBase: EnvironmentBase, parameters: [String: Any]) -> String {
        var url = string
        
        parameters.forEach { (parameter) in
            if url.contains("{\(parameter.key)}") {
                let array = url.components(separatedBy: "{\(parameter.key)}")
                if array.count == 2 { url = "\(array[0])\(parameter.value)\(array[1])" }
            }
        }
        
        return environmentBase == .theMovieDB ? url + apiKey : url
    }
    
    var apiKey: String {
        return "api_key=\(RequestUrl.apiKey.path)"
    }
}
