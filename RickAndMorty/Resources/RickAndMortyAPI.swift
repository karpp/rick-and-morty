//
//  RickAndMortyAPI.swift
//  RickAndMorty
//
//  Created by Egor Karpov on 05.02.2023.
//

import Combine
import Foundation

struct Character: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let image: String
}

struct CharactersSearch: Codable {
    let results: [Character]
}

final class APIClient {
    private let urlSession: URLSession
    private let APIUrl: String = "https://rickandmortyapi.com/api/"
    
    init(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func getCharacter(id characterID: Int) -> AnyPublisher<Character, Error> {
        print("CALLED API FOR ID \(characterID)")
        let url = URL(string: APIUrl + "character/\(characterID)")!
        return executeRequest(url: url)
    }
    
    func search(query: String) -> AnyPublisher<CharactersSearch, Error> {
        let url = URL(string: APIUrl + "character/?name=\(query)")!
        return executeRequest(url: url)
    }
    
    private func executeRequest<T: Codable>(url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher();
    }
}
