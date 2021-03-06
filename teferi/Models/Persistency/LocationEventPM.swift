import Foundation
import CoreData

struct LocationEventPM
{
    let timeStamp: Date
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let accuracy: Double
}

extension LocationEventPM: PersistencyModel
{
    static var entityName: String = "Location"
    
    init(managedObject: NSManagedObject) throws
    {
        guard let timeStamp = managedObject.value(forKey: "timeStamp") as? Date,
            let latitude = managedObject.value(forKey: "latitude") as? Double,
            let longitude = managedObject.value(forKey: "longitude") as? Double,
            let altitude = managedObject.value(forKey: "altitude") as? Double,
            let accuracy = managedObject.value(forKey: "horizontalAccuracy") as? Double else {
                throw PersistencyError.couldntParse
        }
        
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.accuracy = accuracy
    }
    
    func encode() -> NSManagedObject
    {
        fatalError("Not implemented")
    }
}


extension LocationEventPM
{
    static func all(fromDate startDate: Date, toDate endDate: Date) -> CoreDataResource<[LocationEventPM]>
    {
        let predicate = Predicate(parameter: "timeStamp", rangesFromDate: startDate as NSDate, toDate: endDate as NSDate)
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: true)
        return CoreDataResource<[LocationEventPM]>.many(predicate: predicate, sortDescriptor: sortDescriptor)
    }
}
