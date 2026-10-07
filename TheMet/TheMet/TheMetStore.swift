//
//  TheMetStore.swift
//  TheMet
//
//  Created by Jonathan S. on 10/6/26.
//

import Foundation

@MainActor
final class TheMetStore: ObservableObject {
    @Published var objects: [Object] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let service = TheMetService()
    private let maxObjects: Int

    init(_ maxObjects: Int = 12) { self.maxObjects = maxObjects }

    func fetchObjects(for query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isLoading = true; errorMessage = nil
        do {
            guard let ids = try await service.getObjectIDs(from: query) else { throw URLError(.badServerResponse) }
            var downloaded: [Object] = []
            for id in ids.objectIDs.prefix(maxObjects) {
                if let object = try await service.getObject(from: id) { downloaded.append(object) }
            }
            objects = downloaded
        } catch {
            errorMessage = error.localizedDescription
            objects = [Object.sample(), Object.sample(isPublicDomain: false)]
        }
        isLoading = false
    }
}
