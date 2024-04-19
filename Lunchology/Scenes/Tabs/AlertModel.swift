//
//  AlertModel.swift
//  Lunchology
//
//  Created by Ivana Soric Strize on 15.04.2024..
//

import Foundation
import SwiftUI

class AlertModel: ObservableObject {
    public static let shared = AlertModel()
    @Published var alert: AlertWindow?
}

struct AlertWindow: Identifiable {
    enum AlertType {
        case upload
        case uploadComplete
        case uploadError
    }

    let id: AlertType
    var title: String {
        switch id {
        case .upload:
            return "Upload to Server"
        case .uploadComplete:
            return "Upload Complete"
        case .uploadError:
            return "Upload Error"
        }
    }
    let message: String
    var dismissButton: Alert.Button? = Alert.Button.default(Text("OK"))
    
    var hasCancelButton: Bool {
        switch id {
        case .upload:
            return true
        default:
            return false
        }
    }
}
