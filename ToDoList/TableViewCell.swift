//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Alper Canımoğlu on 2.01.2023.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var starButton: UIButton!
   
    var starFlag : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starClickButton(_ sender: Any) {
        if self.starFlag == false {
            self.starButton.setImage(UIImage(systemName: "star.fill"), for: UIControl.State.normal)
            self.starFlag = true
        }else{
            self.starButton.setImage(UIImage(systemName: "star"), for: UIControl.State.normal)
            self.starFlag = false
        }
    }
    
}
