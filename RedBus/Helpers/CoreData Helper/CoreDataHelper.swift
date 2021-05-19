//
//  CoreDataHelper.swift
//  RedBus
//
//  Created by pranay chander on 19/05/21.
//

import CoreData

class CoreDataHelper {

    static func createBusData(jsonData: [String: Any], context: NSManagedObjectContext) {
        let metaData = jsonData["metaData"] as? [String: Any]
        let source = metaData?["src"] as? String
        let destination = metaData?["dst"] as? String
        let logo = metaData?["blu"] as? String
        let currency = metaData?["currency"] as? String

        guard let busListData = jsonData["inv"]  as? [[String: Any]]  else {
            return
        }

        let jsonDateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter
        }()

        let rbEntity = RBData(context:context)

        do {
            let existingRBData = try context.fetch(RBData.fetchRequest())
            let existingBusData = try context.fetch(Bus.fetchRequest())
            existingRBData.forEach { object in
                do {
                    context.delete(object as! NSManagedObject)
                    try context.save()
                } catch {
                    print("Couldnt Delete")
                }
            }
            existingBusData.forEach { object in
                do {
                    context.delete(object as! NSManagedObject)
                    try context.save()
                } catch {
                    print("Couldnt Delete")
                }
            }
        } catch {
            print("Couldnt Fetch")
        }


        rbEntity.source = source
        rbEntity.destination = destination
        rbEntity.currency = currency

        busListData.forEach { bus in
            let busEntity = Bus(context: context)

            if let depDateString = bus["dt"] as? String, let depDate = jsonDateFormatter.date(from: depDateString) {
                busEntity.departureTime = depDate
            }

            if let arrDateString = bus["at"] as? String, let arrDate = jsonDateFormatter.date(from: arrDateString) {
                busEntity.arrivalTime = arrDate
            }

            busEntity.travelsName = bus["Tvs"] as? String
            busEntity.rating = (bus["rt"] as? [String: Any])?["totRt"] as? Double ?? 0.0
            busEntity.busLogoUrl = (logo ?? "") + (bus["lp"] as? String ?? "")
            busEntity.fare = bus["minfr"] as? Double ?? 0.0
            busEntity.isAC = (bus["bc"] as? [String: Bool])?["isAC"] ?? false
            busEntity.isNonAC = (bus["bc"] as? [String: Bool])?["IsNonAc"] ?? false
            busEntity.isSeater = (bus["bc"] as? [String: Bool])?["IsSeater"] ?? false
            busEntity.isSleeper = (bus["bc"] as? [String: Bool])?["IsSleeper"] ?? false

            rbEntity.addToBusList(busEntity)
        }

        do {
            try context.save()
        } catch  {
            print("Couldnt Save")
        }
    }
}
