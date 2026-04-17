//
//  MyFirstCloudApp.swift
//  MyFirstCloud
//
//  Created by Linus Ilbratt on 2026-04-17.
//

import FirebaseCore
import SwiftUI

@main
struct MyFirstCloudApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
