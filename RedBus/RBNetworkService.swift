//
//  RBNetworkService.swift
//  RedBus
//
//  Created by pranay chander on 17/05/21.
//

import UIKit
import CoreData

class RBNetworkService {

    static func getBuses(completion: @escaping(RBData)->()) {
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
            guard let createdBusData = createBusData(jsonData: decodedData) else {
                return
            }
            completion(createdBusData)

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

    static func createBusData(jsonData: [String: Any]) -> RBData? {
        let metaData = jsonData["metaData"] as? [String: Any]
        let source = metaData?["src"] as? String
        let destination = metaData?["dst"] as? String
        let logo = metaData?["blu"] as? String
        let currency = metaData?["currency"] as? String

        guard let busListData = jsonData["inv"]  as? [[String: Any]]  else {
            return nil
        }

        let jsonDateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter
        }()


        let busListParsed = busListData.map { bus in
                return Bus(
                    departureTime: bus["dt"] as? String,
                    arrivalTime: bus["at"] as? String,
                    travelsName: bus["Tvs"] as? String,
                    rating: (bus["rt"] as? [String: Any])?["totRt"] as? Double,
                    busLogo: (logo ?? "") + (bus["lp"] as? String ?? ""),
                    fare: bus["minfr"] as? Double,
                    isAC: (bus["bc"] as? [String: Bool])?["isAC"],
                    isNonAC: (bus["bc"] as? [String: Bool])?["IsNonAc"],
                    isSeater: (bus["bc"] as? [String: Bool])?["IsSeater"],
                    isSleeper: (bus["bc"] as? [String: Bool])?["IsSleeper"])
            }
        

        return RBData(source: source, destination: destination, currency: currency, busList: busListParsed)
    }
}

//struct RBData {
//    let source: String?
//    let destination: String?
//    let currency: String?
//    let busList: [Bus]?
//}
//
//struct Bus {
//    let departureTime: String?
//    let arrivalTime: String?
//    let travelsName: String?
//    let rating: Double?
//    let busLogo: String?
//    let fare: Double?
//    let isAC: Bool?
//    let isNonAC: Bool?
//    let isSeater: Bool?
//    let isSleeper: Bool?
//}


