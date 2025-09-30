//
//  ProfileController.swift
//  RegistroUsuario452
//
//  Created by José Molina on 12/09/25.
//

import Foundation
import Combine

struct ProfileController{
    
    private var profileClient = ProfileClient()
    
    
    init(profileClient: ProfileClient)  {
        self.profileClient = profileClient
    }
    
   func getProfile() async throws->Profile{
        let accessToken=TokenStorage.get(identifier: "accessToken")
        
       let response = try await profileClient.getUserProfile(token: accessToken!)
        return response.profile
    }
    
    
}
