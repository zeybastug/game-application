//
//  ServiceOperations.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 9.12.2022.
//

import Foundation
import UIKit
import Kingfisher

class Client {
    
    enum Endpoints {
        static let base = "https://api.rawg.io/api/games"
        
        case games
        case details(Int)
        case genres(String)
        case selectGenres
        case search(String)
        
        static let key = "key=d0e751f5856542b9b6ced544ca35ae97"
        
        var stringValue: String {
            switch self {
            case .games:
                return "\(Endpoints.base)?\(Endpoints.key)"
            case .details(let id):
                return "\(Endpoints.base)/\(id)?\(Endpoints.key)"
            case .genres(let genre):
                return "\(Endpoints.base)?genres=\(genre)&\(Endpoints.key)"
//            https://api.rawg.io/api/games?genres=action&key=d0e751f5856542b9b6ced544ca35ae97
            case .selectGenres:
                return "https://api.rawg.io/api/genres?\(Endpoints.key)"
            case .search(let game):
                return "\(Endpoints.base)?search=\(game)&\(Endpoints.key)"
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
                print(error)
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
    class func getDetails(id:Int,completion: @escaping (DetailModel?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.details(id).url, responsetType: DetailModel.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getGenres(genre:String,completion: @escaping (Result?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.genres(genre).url, responsetType: Result.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func getGenreOptions(completion: @escaping (ResultModel?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.selectGenres.url, responsetType: ResultModel.self) {response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }

    class func getSearchedGames(game:String, completion: @escaping (Result?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.search(game).url, responsetType: Result.self) {response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
//    class func downloadImages(image:String, imageView:UIImageView){
//       DispatchQueue.main.async {
//           let url = URL(string: image)
//           imageView.kf.setImage(with: url)
//       }
//   }
    
    class func setImage(onImageView image:UIImageView,withImageUrl imageUrl:String?,placeHolderImage: UIImage){

            if let imgurl = imageUrl{
                image.kf.indicatorType = IndicatorType.activity
                image.kf.setImage(with: URL(string: imgurl), placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: { response in
                })
            }
            else{
                image.image = placeHolderImage
            }
        
        
        }
}
