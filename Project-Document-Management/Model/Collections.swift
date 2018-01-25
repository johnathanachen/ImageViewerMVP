//
//  Collections.swift
//  Project-Document-Management
//
//  Created by Johnathan Chen on 1/24/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import Foundation

struct Collections {
    let collectionName: String
    let zippedImagesUrl: URL
    var unzippedImagesUrl: URL?
    var unzippingProgress: Double?
}

extension Collections: Decodable {
    enum Keys: String, CodingKey {
        case collectionName = "collection_name"
        case zippedImagesUrl = "zipped_images_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let collectionName = try container.decode(String.self, forKey: .collectionName)
        let zippedImagesUrl = try container.decode(URL.self, forKey: .zippedImagesUrl)
        self.init(collectionName: collectionName, zippedImagesUrl: zippedImagesUrl, unzippedImagesUrl: nil, unzippingProgress: nil)
    }
}
