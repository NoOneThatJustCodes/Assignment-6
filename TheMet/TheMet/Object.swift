//
//  Object.swift
//  TheMet
//
//  Created by Jonathan S. on 10/5/26.
//

import Foundation

struct Object: Codable, Identifiable, Hashable {
    let objectID: Int
    let title: String
    let creditLine: String
    let objectURL: String
    let isPublicDomain: Bool
    let primaryImageSmall: String
    var id: Int { objectID }

    static func sample(isPublicDomain: Bool = true) -> Object {
        if isPublicDomain {
            return Object(objectID: 452174,
                          title: "Bahram Gur Slays the Rhino-Wolf",
                          creditLine: "Gift of Arthur A. Houghton Jr., 1970",
                          objectURL: "https://www.metmuseum.org/art/collection/search/452174",
                          isPublicDomain: true,
                          primaryImageSmall: "https://images.metmuseum.org/CRDImages/is/original/DP107178.jpg")
        }
        return Object(objectID: 828444,
                      title: "Hexagonal flower vase",
                      creditLine: "Gift of Samuel and Gabrielle Lurie, 2019",
                      objectURL: "https://www.metmuseum.org/art/collection/search/828444",
                      isPublicDomain: false,
                      primaryImageSmall: "")
    }
}

struct ObjectIDs: Codable { let total: Int; let objectIDs: [Int] }
