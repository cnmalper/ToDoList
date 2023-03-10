//
//  SecondViewController.swift
//  ToDoList
//
//  Created by Alper Canımoğlu on 2.01.2023.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedTodo = ""
    var selectedTodoID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedTodo != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            let idString = selectedTodoID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0  {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            titleText.text = title
                        }
                        if let desc = result.value(forKey: "desc") as? String {
                            descText.text = desc
                        }
                        if let date = result.value(forKey: "date") as? String {
                            dateText.text = date
                        }
                    }
                }
            }catch{
                Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not be retrieved!", vc: self)
            }
        }
        
    }
    
    @IBAction func saveButonClicked(_ sender: Any) {
        
        if self.titleText.text != "" && self.descText.text != "" && dateText.text != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newTodo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)

            // Attributes

            newTodo.setValue(titleText.text!, forKey: "title")
            newTodo.setValue(dateText.text!, forKey: "date")
            newTodo.setValue(descText.text!, forKey: "desc")
            newTodo.setValue(UUID(), forKey: "id")

            do{
                try context.save()
            }catch{
                Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not be saved!", vc: self)
            }
            
            NotificationCenter.default.post(name:NSNotification.Name("newTodo"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }else{
            Common.showAlert(errorTitle: "Error!", errorMessage: "Missing data! Please type all of your information.", vc: self)
        }
        
    }
    
}
