//
//  App.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import SwiftUI

@main
struct TheMetApp: App {
    @StateObject private var store = TheMetStore()
    var body: some Scene {
        WindowGroup { ContentView().environmentObject(store) }
    }
}
