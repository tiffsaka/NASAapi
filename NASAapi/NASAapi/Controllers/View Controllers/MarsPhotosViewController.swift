//
//  MarsPhotosViewController.swift
//  NASAapi
//
//  Created by Tiffany Sakaguchi on 5/5/21.
//

import UIKit

class MarsPhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var instructionsLabel: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - Properties
    var photos: [MarsSecondLevelObject] = []
    static var userChosenDate = ""
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let selectedDate = datePicker.date
        print(selectedDate)
        let dateString = DateFormatter.formatDate(date: selectedDate)
        print("Date String: \(dateString)")
        fetchForTableView(date: dateString)
    }

    //MARK: - Functions
    
    func fetchForTableView(date: String) {
        MarsDataController.fetchData(searchDate: date) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.photos = data
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
}//End of class

//MARK: - Extensions



extension MarsPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count = \(photos.count)")
        return photos.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? MarsTableViewCell
        let items = photos[indexPath.row]
        cell?.photo = items
        return cell ?? UITableViewCell()
    }
}
