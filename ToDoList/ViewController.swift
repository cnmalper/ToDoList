//
//  ViewController.swift
//  ToDoList
//
//  Created by Alper Canımoğlu on 2.01.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editTableButton: UIBarButtonItem!
    
    var idArray = [UUID]()
    var titleArray = [String]()
    var descArray = [String]()
    var dateArray = [String]()
    var myCellList = [TableViewCell]()
    var chosenTodo = ""
    var chosenTodoID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(goToSecondVC))

        getData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newTodo"), object: nil)
    }
    
    @objc func getData(){
        
        self.idArray.removeAll(keepingCapacity: false)
        self.titleArray.removeAll(keepingCapacity: false)
        self.descArray.removeAll(keepingCapacity: false)
        self.dateArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let title = result.value(forKey: "title") as? String {
                    self.titleArray.append(title)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                if let desc = result.value(forKey: "desc") as? String {
                    self.descArray.append(desc)
                }
                if let date = result.value(forKey: "date") as? String {
                    self.dateArray.append(date)
                }
            }
            self.tableView.reloadData()
        }catch{
            Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not be retrieved!", vc: self)
        }
        
    }
    
    @objc func goToSecondVC(){
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.titleLbl.text = self.titleArray[indexPath.row]
        cell.descLbl.text = self.descArray[indexPath.row]
        cell.dateLbl.text = self.dateArray[indexPath.row]
        self.myCellList.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                
                                context.delete(result)
                                self.idArray.remove(at: indexPath.row)
                                self.titleArray.remove(at: indexPath.row)
                                self.dateArray.remove(at: indexPath.row)
                                self.descArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                }catch{
                                    Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not be deleted. (1)", vc: self)
                                }
                                break
                            }
                        }
                    }
                }
            }catch{
                Common.showAlert(errorTitle: "Error!", errorMessage: "Data could not be deleted. (2)", vc: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        let itemMove = myCellList[sourceIndexPath.row]
        myCellList.remove(at: sourceIndexPath.row)
        myCellList.insert(itemMove, at: destinationIndexPath.row)
        // The new sorted list have to save. I don't know how??
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondVC" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.selectedTodo = chosenTodo
            destinationVC.selectedTodoID = chosenTodoID
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTodo = titleArray[indexPath.row]
        chosenTodoID = idArray[indexPath.row]
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    
    @IBAction func didSortTableView(_ sender: Any) {
        
        if tableView.isEditing {
            tableView.isEditing = false
            self.editTableButton.title = "Edit"
        }else{
            tableView.isEditing = true
            self.editTableButton.title = "Done"
        }
    }

}

