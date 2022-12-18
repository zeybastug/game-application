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
        
        case games(Int)
        case details(Int)
        case genres(String, Int)
        case selectGenres
        case search(String, Int)
        case searchAndGenre(String,String,Int)
        
        static let key = "key=d0e751f5856542b9b6ced544ca35ae97"
        
        var stringValue: String {
            switch self {
            case .games(let page):
                return "\(Endpoints.base)?page=\(page)&\(Endpoints.key)"
            case .details(let id):
                return "\(Endpoints.base)/\(id)?\(Endpoints.key)"
            case .genres(let genre, let page):
                return "\(Endpoints.base)?genres=\(genre)&page=\(page)&\(Endpoints.key)"
                //            https://api.rawg.io/api/games?genres=action&key=d0e751f5856542b9b6ced544ca35ae97
            case .selectGenres:
                return "https://api.rawg.io/api/genres?\(Endpoints.key)"
            case .search(let game, let page):
                return "\(Endpoints.base)?search=\(game)&page=\(page)&\(Endpoints.key)"
            case .searchAndGenre(let game,let genre,let page):
                return "\(Endpoints.base)?search=\(game)&genres=\(genre)&page=\(page)&\(Endpoints.key)"
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
    
    class func getGames(page:Int, completion: @escaping (Result?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.games(page).url, responsetType: Result.self) { response, error in
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
    
    class func getGenreOptions(completion: @escaping (ResultModel?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.selectGenres.url, responsetType: ResultModel.self) {response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getSearchedAndFilteredGames(page:Int, game:String,genre:String, completion: @escaping (Result?, Error?) -> Void) {
        var url:URL? = nil
        if(game != "" && genre != "")
        {
            url = Endpoints.searchAndGenre(game, genre, page).url
        }
        else if(game != "")
        {
            url = Endpoints.search(game, page).url
        }
        else if(genre != "")
        {
            url = Endpoints.genres(genre, page).url
        }
        else
        {
            url = Endpoints.games(page).url
        }
        taskForGETRequest(url: url!, responsetType: Result.self) {response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func setImage(onImageView image:UIImageView,withImageUrl imageUrl:String?,placeHolderImage: UIImage){
        if(imageUrl != "")
        {
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
}
