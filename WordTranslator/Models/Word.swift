//
//  WordModel.swift
//  WordTranslator
//
//  Created by Артем Мак on 13.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

//MARK: - Word
struct Word: Decodable {
    var text: String?
    var meanings: [Meaning]
}

// MARK: - Meaning
struct Meaning: Decodable {
    var id: Int?
    var translation: Translation?
    var previewUrl: String?
    var imageUrl: String?
}

// MARK: - Translation
struct Translation: Decodable {
    var text: String?
}
