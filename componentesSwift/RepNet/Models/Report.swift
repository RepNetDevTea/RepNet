//
//  Report.swift
//  RepNet
//
//  Created by Angel Bosquez on 29/09/25.
//


import Foundation
import SwiftUI

// modelo de datos para reportes
// se supone que se llena con datos de la api

struct Report: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let category: String
    let severity: String
    let statusText: String
    let statusColor: Color
}
