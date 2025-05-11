//
//  CrashlyticsManager.swift
//  QuotesApp
//
//  Created by Mateusz Grudzień on 08/05/2025.
//

import Foundation
import Firebase
import FirebaseCrashlytics

protocol CrashlyticsManagerInterface {
    func record(_ error: Error)
    func log(_ message: String)
}

final class CrashlyticsManager: CrashlyticsManagerInterface {
    init() {
        FirebaseApp.configure()
    }
    
    func record(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
    
    func log(_ message: String) {
        Crashlytics.crashlytics().log(message)
    }
}
