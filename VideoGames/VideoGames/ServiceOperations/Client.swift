//
//  ServiceOperations.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 9.12.2022.
//

import Foundation

class Client {
    
    enum Endpoints {
        static let base = "https://api.rawg.io/api/games?key=d0e751f5856542b9b6ced544ca35ae97"
        
        case games
        
        case genres
        
        var stringValue: String {
            switch self {
            case .games:
                return Endpoints.base
            case .genres:
                return Endpoints.base + "/genres" //bu farklı api gibi, filtre için nasıl yapıcam?
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responsetType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) ->
    URLSessionDataTask {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(BaseResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    class func getGames(completion: @escaping (Result?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.games.url, responsetType: Result.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}

