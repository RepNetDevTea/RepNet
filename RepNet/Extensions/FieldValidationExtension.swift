//
//  FieldValidationExtension.swift
//  RepNet
//
//  Created by Angel Bosquez on 01/10/25.
//

import Foundation

// "Extendemos" el tipo String, dándole nuevas propiedades y "habilidades".
extension String {
    
    // Devuelve 'true' si el String tiene un formato de correo electrónico válido.
    // (Sin cambios, ya que usa regex de la forma recomendada).
    var esCorreoValido: Bool {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPredicate.evaluate(with: self)
    }
    
    // --- NUEVAS PROPIEDADES PARA LA LONGITUD DE LA CONTRASEÑA ---
    
    // Devuelve 'true' si el String cumple con la longitud mínima requerida.
    var tieneLongitudMinima: Bool {
        return self.count >= 8
    }
    
    // Devuelve 'true' si el String no excede la longitud máxima.
    var tieneLongitudMaxima: Bool {
        return self.count <= 20
    }
    
    // --- PROPIEDADES EXISTENTES (con mejora en CaracterEspecial) ---
    
    var tieneMayuscula: Bool {
        return self.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    
    var tieneNumero: Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    // --- MEJORA ---
    // Ahora incluye un conjunto más completo de caracteres especiales comunes.
    // La prevención de inyección SQL es responsabilidad del backend.
    var tieneCaracterEspecial: Bool {
        // Buscamos la presencia de cualquiera de los caracteres dentro del conjunto [].
        // MODIFICADO: El conjunto de caracteres especiales ahora está limitado a los que solicitaste.
        return self.range(of: "[!@#$%^&*?]", options: .regularExpression) != nil
    }
    
}
