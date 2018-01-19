//
//  ViewController.swift
//  TooDoo
//
//  Created by Henrik Anthony Odden Sandberg on 12.01.2018.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//

import UIKit
import CoreData

class TooDooViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Gir filstien til appen.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView Datasource Methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as UITableViewCell!
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Deligate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveToFile()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add new TooDoo", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addTextField { (alertTextFeeld) in
            alertTextFeeld.placeholder = "Creat new item"
            textField = alertTextFeeld
        }
        
        //Cancel Button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        //Add Button
        alert.addAction(UIAlertAction(title: "Add Item", style: .default) { (addItem) in
            //What will happen when
            
            if let tekst = textField.text{
                self.addToArray(tekst)
            }
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    func addToArray(_ text: String){
        if text != ""{
            
            let newItem = Item(context: context)
            newItem.title = text
            newItem.checked = false
            newItem.parentCategory = selectedCategory
            itemArray.append(newItem)
            saveToFile()
        }
    }
    
    //MARK: - From File methodes
    func saveToFile(){
        do{
            try context.save()
        } catch {
            print("Error saving item: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(_ request: NSFetchRequest<Item> = Item.fetchRequest(), withPredicate: NSPredicate? = nil){
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name!)!)
        
        if let otherPredicate = withPredicate{
            let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, otherPredicate])
            request.predicate = compundPredicate
            
        } else {
            request.predicate = predicate
        }
        
        
        do{
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch{
            print("Error with load: \(error)")
        }
        
    }
    
}


//MARK: - Search Bar Delegate
extension TooDooViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        if let search = searchBar.text {
            if search != ""{
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
                request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
                loadItems(request, withPredicate: predicate)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}





















