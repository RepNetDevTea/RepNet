//
//  EnvironmentExtension.swift
//  RegistroUsuario452
//
//  Created by José Molina on 29/08/25.
//

import Foundation
import SwiftUICore

extension EnvironmentValues {
    @Entry var authController = AuthenticationController(httpClient: HTTPClient())
}
