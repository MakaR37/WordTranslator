//
//  NetworSevice.swift
//  WordTranslator
//
//  Created by Артем Мак on 18.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//
import Foundation

class WordSearchNetworkService {
    static let shared = WordSearchNetworkService()
    func getWord(by text: String,completion: @escaping (Result<[Word],Error>) -> Void) {
        let apiLink = "https://dictionary.skyeng.ru/api/public/v1/words/search?search=\(text)"
        guard let url = URL(string: apiLink) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            if let error = error {
                completion(.failure(error))
            }
            do {
                let words = try JSONDecoder().decode([Word].self, from: data)
                completion(.success(words))
                return
            } catch {
                completion(.failure(error))
                return
            }
            }.resume()
    }
    
    func getWordDetails(id: Int, completeon: @escaping (Result<[WordDetails], Error>) -> Void) {
        let getWordDetails = "https://dictionary.skyeng.ru/api/public/v1/meanings?ids=\(id)"
        guard let linkApi = URL(string: getWordDetails) else {
            return
        }
        URLSession.shared.dataTask(with: linkApi) { (data, response, error) in
            guard let data = data else {
                completeon(.failure(NSError(domain: "", code: 0, userInfo: nil)))
                return
            }
            if let error = error {
                completeon(.failure(error))
                return
            }
            do {
                let words = try JSONDecoder().decode([WordDetails].self, from: data)
                completeon(.success(words))
            }catch{
                completeon(.failure(error))
            }
            }.resume()
    }
}
