//
//  ViewController.swift
//  TravelLocation
//
//  Created by ipick on 07/05/21.
//


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var travelListTableView : UITableView!
    
    var locationViewModel = LocationViewModel()
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationViewModel.fetchSavedData { (location) in
            self.locations = location
        }
        
        self.locationViewModel.reloadClosure = {
            self.locationViewModel.fetchSavedData { (location) in
                self.locations = location
                self.travelListTableView.reloadData()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.locationViewModel.updateLcation()
        }
        
    }
   
}
extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            let location = self.locations[indexPath.row]
            cell!.textLabel?.text = "Lat: \(location.lat ?? "") \nLong: \(location.long ?? "") \nTime:\(location.time ?? "")"
            cell!.textLabel?.numberOfLines = 0
        }
        return cell!
        
    }
    
}



