//
//  ContentView.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: TheMetStore
    @State private var query = "persimmon"
    @State private var showSearch = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {

                if !query.isEmpty {
                    Text("You searched for '(query)'")
                        .font(.caption)
                        .padding(6)
                }

                if store.isLoading {
                    ProgressView()
                        .padding()
                }

                List(store.objects) { object in
                    NavigationLink(value: object) {
                        if object.isPublicDomain {
                            HStack {
                                Text(object.title)

                                Spacer()

                                Image(systemName: "doc.text.image.fill")
                            }
                        } else {
                            WebIndicatorView(title: object.title)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("The Met")

            .navigationDestination(for: Object.self) { object in
                ObjectView(object: object)
            }

            .navigationDestination(for: URL.self) { url in
                SafariView(url: url)
            }

            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showSearch = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }

            .task {
                await store.fetchObjects(for: query)
            }

            .onOpenURL { url in
                guard let id = url.host,
                      let object = store.objects.first(where: {
                          String($0.objectID) == id
                      }) else {
                    return
                }

                if object.isPublicDomain {
                    path.append(object)
                } else if let url = URL(string: object.objectURL) {
                    path.append(url)
                }
            }

            .alert("Search", isPresented: $showSearch) {
                TextField("Search term", text: $query)

                Button("Search") {
                    Task {
                        await store.fetchObjects(for: query)
                    }
                }

                Button("Cancel", role: .cancel) {
                }
            }
        }
    }
}
