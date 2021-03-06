//
//  CategoryViewController.swift
//  TooDoo
//
//  Created by Henrik Anthony Odden Sandberg on 17.01.2018.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryCatalog = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategorys()
    }
    
    //MARK: Load & Save
    func saveToCategories(){
        do{
            try context.save()
        } catch {
            print("Error saving item: \(error)")
        }
        loadCategorys()
    }
    
    func loadCategorys(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryCatalog = try context.fetch(request)
            tableView.reloadData()
        } catch{
            print("Error with load: \(error)")
        }
    }

    //MARK: Add new catalog to teh catalog list
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create new Category", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addTextField { (alertTextFeeld) in
            alertTextFeeld.placeholder = "Add a name"
            textField = alertTextFeeld
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancel) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (addBtn) in
            self.addCatalog(textField.text!)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func addCatalog(_ text: String){
        if text != ""{
            let newCategory = Category(context: context)
            newCategory.name = text
            categoryCatalog.append(newCategory)
            saveToCategories()
        }
    }

    //MARK: TableView Datasource Methodes
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryCatalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as UITableViewCell!
        cell?.textLabel?.text = categoryCatalog[indexPath.row].name!
        return cell!
    }
    
    //MARK: TableView Delegate Methodes
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Valgte celle \(categoryCatalog[indexPath.row].name!)")
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TooDooViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryCatalog[indexPath.row]
        }
    }
    
    //MARK: Data Manipulation Methodes
    
}













