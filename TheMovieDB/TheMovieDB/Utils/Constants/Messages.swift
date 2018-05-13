//
//  Messages.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

enum Messages: String {
    case emptySearch = "There are no movies available"
    case searchMovie = "Search a movie"
    case searchTVShow = "Search a TV Show"
    case searchPerson = "Search a person"
    case didSelect = "Did select"
    case didAnsweredPersonalityTest = "Did answered personality test - Type: "
    
    case userRegisterMessage = "Hey dude, You can start by creating an account"
    case invalidUser = "Invalid user"
    case invalidEmail = "Invalid email"
    case invalidPassword = "Invalid password\nYour password must have at least 6 characteres"
    case invalidPasswordConfirmation = "Passwords do not match"
    case serverError = "An error has occurred on our servers\nTry again later"
    
    case resetPassword = "An email was sent to reset your password"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
