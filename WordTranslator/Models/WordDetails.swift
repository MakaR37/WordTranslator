//
//  File.swift
//  WordTranslator
//
//  Created by Артем Мак on 20.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import Foundation

//MARK: - WordDetails
struct WordDetails: Decodable {
    let id: String?
    let text: String?
    var soundUrl: String?
    let translation: TranslationWord?
    let definition: Definition?
    var images: [Image]?
    let examples:[Definition]?
    let transcription: String?
    let meaningsWithSimilarTranslation: [MeaningsWithSimilarTranslation]?
}

//MARK: - Definition
struct Definition: Decodable {
    let text: String?
    let soundUrl: String?
}

//MARK: - Image
struct Image: Decodable {
    var url: String?
}

//MARK: - TranslationWord
struct TranslationWord: Decodable {
    let text: String?
    let note: String?
}

//MARK: - MeaningsWithSimilarTranslation
struct MeaningsWithSimilarTranslation: Decodable {
    let partOfSpeechAbbreviation: String?
}
