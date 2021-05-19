//
//  RBNetworkService.swift
//  RedBus
//
//  Created by pranay chander on 17/05/21.
//

import UIKit
import CoreData

class RBNetworkService {

    static func getBuses(context: NSManagedObjectContext) {
        let api = "https://api.jsonbin.io/b/6093c95293e0ce40806d8a1d"
        let url = URL(string: api)!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                return
            }
            guard let decodedData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            CoreDataHelper.createBusData(jsonData: decodedData, context: context)
        }.resume()
    }

    static func getBusLogo(url: String, completion: @escaping(UIImage?)->()) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { Data, URLResponse, Error in
            guard let data = Data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}

