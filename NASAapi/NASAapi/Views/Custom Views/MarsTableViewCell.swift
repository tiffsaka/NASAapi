//
//  MarsTableViewCell.swift
//  NASAapi
//
//  Created by Tiffany Sakaguchi on 5/5/21.
//

import UIKit

class MarsTableViewCell: UITableViewCell {

    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var roverLabel: UILabel!
    
    
    var photo: MarsSecondLevelObject? {
        didSet {
            updateViews()
        }
    }
    
   
    func updateViews() {
        guard let marsPhoto = photo else { return }
        dateLabel.text = "Photo Date: \(marsPhoto.earth_date)"
        roverLabel.text = "Rover: \(marsPhoto.rover.name)"
        
        MarsDataController.fetchImage(image: marsPhoto) { (result) in
            DispatchQueue.main.async {
                switch result {
                
                case .success(let photo):
                    self.marsImageView.image = photo
                case .failure(let error):
                    self.marsImageView.image = UIImage(systemName: "questionmark")
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        marsImageView.image = nil
        dateLabel.text = nil
        roverLabel.text = nil
    }
    
    
}
