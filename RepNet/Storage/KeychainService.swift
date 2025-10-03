//
//  KeychainService.swift
//  RepNet
//
//  Created by Angel Bosquez on 30/09/25.
//

import Foundation
import Security

// Este servicio se encarga de guardar y leer los tokens de forma segura en el Keychain.
class KeychainService {
    
    // Guardamos ambos tokens que recibimos del backend.
    static func saveTokens(accessToken: String, refreshToken: String) throws {
        try save(token: accessToken, identifier: "com.repnet.accessToken")
        try save(token: refreshToken, identifier: "com.repnet.refreshToken")
    }
    
    // Una función genérica y privada para guardar un valor en el Keychain.
    private static func save(token: String, identifier: String) throws {
        // Convertimos el token a un formato que el Keychain pueda guardar.
        let data = Data(token.utf8)
        
        // Creamos una "consulta" para identificar el dato que queremos guardar.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Le decimos que es una contraseña genérica.
            kSecAttrAccount as String: identifier,         // Usamos un identificador único.
            kSecValueData as String: data                  // Los datos en sí.
        ]
        
        // Por seguridad, siempre eliminamos cualquier valor antiguo antes de guardar el nuevo.
        SecItemDelete(query as CFDictionary)
        
        // Añadimos el nuevo item al Keychain.
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Verificamos que la operación haya sido exitosa.
        guard status == errSecSuccess else {
            throw NSError(domain: NSOSStatusErrorDomain, code: Int(status))
        }
        print("✅ Token guardado exitosamente en el Keychain con el identificador: \(identifier)")
    }
    
    // Recuperamos el accessToken (lo usaremos para las llamadas a la API).
    static func getAccessToken() -> String? {
        return get(identifier: "com.repnet.accessToken")
    }
    
    // Una función genérica y privada para leer un valor del Keychain.
    private static func get(identifier: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: identifier,
            kSecReturnData as String: kCFBooleanTrue!, // Le pedimos que nos devuelva los datos.
            kSecMatchLimit as String: kSecMatchLimitOne  // Le decimos que solo esperamos un resultado.
        ]
        
        var dataTypeRef: AnyObject?
        // Buscamos en el Keychain usando nuestra consulta.
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Si la búsqueda fue exitosa y los datos existen, los convertimos de vuelta a un String.
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
}
