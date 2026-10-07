//
//  SafariView.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import SwiftUI
import AppKit

struct SafariView: View {
    let url: URL

    var body: some View {
        Text("Opening website…")
            .onAppear {
                NSWorkspace.shared.open(url)
            }
    }
}
