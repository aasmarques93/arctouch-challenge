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
    
    case movieShowNotFound = "No Movie or TV Show was found.\nTry using other filters"
    case movieAddedToWantToSeeList = "Movie added to your want to see list"
    case movieRemovedFromWantToSeeList = "Movie removed from your want to see list"
    case movieAddedToSeenList = "Movie added to your seen list"
    case movieRemovedFromSeenList = "Movie removed from your seen list"
    
    case withoutNetworkConnection = "You have lost your internet connection. Please try again later."
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
