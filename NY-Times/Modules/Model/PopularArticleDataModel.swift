//
//  PopularArticleDataModel.swift
//  NY Times
//
//  Created by Farhan on 17/01/2023.
//

import Foundation

struct RootPopularArticleDataModel: Codable {
    var results: [PopularArticleDataModel]?
}

struct PopularArticleDataModel: Codable {
    var publishedDate: String?
    var author: String?
    var title, abstract: String?
    var media: [Media]?

    enum CodingKeys: String, CodingKey {
        case publishedDate = "published_date"
        case author = "byline"
        case abstract, title
        case media
    }
}

// MARK: - Media
struct Media: Codable {
    var mediaMetadata: [MediaMetaData]?

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

// MARK: - Media Metadata Model
struct MediaMetaData: Codable {
    var url: String?
    var height, width: Int?
}
