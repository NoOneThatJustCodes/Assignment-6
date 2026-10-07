//
//  SupportingViews.swift
//  TheMet
//
//  Created by Jonathan S. on 10/6/26.
//

import SwiftUI

struct WebIndicatorView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title).lineLimit(2)
            Spacer()
            Image(systemName: "safari")
        }
    }
}

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo")
                .font(.largeTitle)
            Text("No image available")
        }
        .frame(maxWidth: .infinity, minHeight: 180)
    }
}
