//
//  CryptoFolioApp2App.swift
//  CryptoFolioApp2
//
//  Created by Martin O Valdes on 15/12/25.
//

import SwiftUI
import FirebaseCore //Importamos el motor de Firebase

@main
struct CryptoFolioApp2App: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
