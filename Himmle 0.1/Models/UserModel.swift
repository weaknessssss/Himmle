//
//  UserModel.swift
//  Himmle 0.1
//
//  Created on 09.03.2025.
//

import Foundation

struct UserModel: Identifiable, Hashable {
    let id: String
    let username: String
    let displayName: String
    let avatarURL: String?
    var isOnline: Bool
    
    // Добавленные поля для профиля
    let dateOfBirth: String?
    let location: String?
    let profession: String?
    let hobby: String?
    let bio: String?
    
    init(id: String,
         username: String,
         displayName: String,
         avatarURL: String? = nil,
         isOnline: Bool = false,
         dateOfBirth: String? = nil,
         location: String? = nil,
         profession: String? = nil,
         hobby: String? = nil,
         bio: String? = nil) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.isOnline = isOnline
        self.dateOfBirth = dateOfBirth
        self.location = location
        self.profession = profession
        self.hobby = hobby
        self.bio = bio
    }
} 