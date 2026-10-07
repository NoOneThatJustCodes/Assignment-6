//
//  TheMetService.swift
//  TheMet
//
//  Created by Jonathan S. on 10/6/26.
//

import Foundation

struct TheMetService {
    let baseURLString = "https://collectionapi.metmuseum.org/public/collection/v1/"
    let session = URLSession.shared
    let decoder = JSONDecoder()

    func getObjectIDs(from queryTerm: String) async throws -> ObjectIDs? {
        var components = URLComponents(string: baseURLString + "search")!
        components.queryItems = [
            URLQueryItem(name: "hasImages", value: "true"),
            URLQueryItem(name: "q", value: queryTerm)
        ]
        let (data, response) = try await session.data(from: components.url!)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else { return nil }
        return try decoder.decode(ObjectIDs.self, from: data)
    }

    func getObject(from objectID: Int) async throws -> Object? {
        let url = URL(string: baseURLString + "objects/\(objectID)")!
        let (data, response) = try await session.data(from: url)
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else { return nil }
        return try decoder.decode(Object.self, from: data)
    }
}
