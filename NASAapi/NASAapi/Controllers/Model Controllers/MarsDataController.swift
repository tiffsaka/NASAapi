//
//  MarsDataController.swift
//  NASAapi
//
//  Created by Tiffany Sakaguchi on 5/5/21.
//

import UIKit

//https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=DEMO_KEY&earth_date=2012-12-25

class MarsDataController {
    
    //MARK: - String Constants
    static let baseURL = URL(string: "https://api.nasa.gov/mars-photos/api")
    static let versionComponent = "v1"
    static let roverComponent = "rovers"
    static let specificRoverComponent = "curiosity"
    static let photoComponent = "photos"
    static let apiKeyKey = "api_key"
    static let apiKeyValue = "DEMO_KEY"
    static let pageKey = "page"
    static let pageValue = "1"
    static let dateKey = "earth_date"
    
    static func fetchData(searchDate: String, completion: @escaping (Result<[MarsSecondLevelObject], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL))}
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let roverURL = versionURL.appendingPathComponent(roverComponent)
        let specificRoverURL = roverURL.appendingPathComponent(specificRoverComponent)
        let photoURL = specificRoverURL.appendingPathComponent(photoComponent)
        
        var components = URLComponents(url: photoURL, resolvingAgainstBaseURL: true)
        
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let pageQuery = URLQueryItem(name: pageKey, value: pageValue)
        let dateQuery = URLQueryItem(name: dateKey, value: searchDate)
        
        components?.queryItems = [apiQuery, pageQuery, dateQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        print("FINAL URL: \(finalURL)")
        
        
        URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            
            if let error = error { return completion(.failure(.thrownError(error)))}
            
            if let response = response as? HTTPURLResponse {
                print("DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData))}
            
            do {
                let marsTopLevelObject = try JSONDecoder().decode(MarsTopLevelObject.self, from: data)
                let marsSecondLevelObject = marsTopLevelObject.photos
                
                var arrayOfPhotos: [RoverNextLevel] = []
                
                for dictionary in marsSecondLevelObject {
                    let item = dictionary.rover
                    arrayOfPhotos.append(item)
                }
                completion(.success(marsSecondLevelObject))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(image: MarsSecondLevelObject, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let imageURL = URL(string: image.img_src) else { return completion(.failure(.invalidURL))}
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("IMAGE STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            completion(.success(image))
        }.resume()
    }
}
