//
//  LocationViewModel.swift
//  TravelLocation
//
//  Created by ipick on 07/05/21.
//


import Foundation
import UIKit
import CoreLocation
import CoreData

class LocationViewModel: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager!

    var reloadClosure : (() -> ()) = {}
    
    func updateLcation()  {

        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        var arr = UserDefaults.standard.object(forKey: "SavedArray") as? [String] ?? [String]()
        arr.append("test")
        UserDefaults.standard.set(arr, forKey: "SavedArray")
        
        let userLocation:CLLocation = locations[0] as CLLocation
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.saveFileData(lat: "\(userLocation.coordinate.latitude)", long: "\(userLocation.coordinate.longitude)")
        
        reloadClosure()
        locationManager.stopUpdatingLocation()
        
    }
    
   func fetchSavedData(completionHandler: @escaping(_ response: [Location]) -> Void) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.returnsObjectsAsFaults = false
  
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as?
                [Location]
            let sortedUsers = result!.sorted {
               (Double($0.time ?? "") ?? 00) < (Double($1.time ?? "") ?? 00)
            }
            
            completionHandler(sortedUsers)
        } catch let error as NSError {
           print(error)
        }
        
    }
    
    
    func saveFileData(lat:String, long:String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let locationEntity = NSEntityDescription.entity(forEntityName: "Location",
                                                     in: managedObjectContext)
        let locationDetails = NSManagedObject(entity: locationEntity!,
                                            insertInto: managedObjectContext) as? Location
        
        locationDetails?.lat = lat
        locationDetails?.long = long
        locationDetails?.time = generateCurrentTimeStamp()
      
        do {
            
            try managedObjectContext.save()
            
        } catch let error as NSError {

            print(error)
        }
    }

    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
