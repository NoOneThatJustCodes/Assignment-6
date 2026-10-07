//
//  ObjectView.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import SwiftUI

struct ObjectView: View {
    let object: Object
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if object.isPublicDomain, let url = URL(string: object.primaryImageSmall) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFit()
                        case .failure: PlaceholderView()
                        default: ProgressView().frame(maxWidth: .infinity, minHeight: 180)
                        }
                    }
                } else { PlaceholderView() }
                Text(object.title).font(.title2).bold()
                Text(object.creditLine).foregroundStyle(.secondary)
                if let url = URL(string: object.objectURL) {
                    Link("View on metmuseum.org", destination: url)
                }
            }.padding()
        }
        .navigationTitle("Object")
    }
}
