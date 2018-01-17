//
//  ViewController.swift
//  TooDoo
//
//  Created by Henrik Anthony Odden Sandberg on 12.01.2018.
//  Copyright © 2018 Henrik Anthony Odden Sandberg. All rights reserved.
//

import UIKit

class TooDooViewController: UITableViewController {
    
    var itemArray : [Item] = []
    
    //Gir filstien til appen.
    let dataFilPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK - TableView Datasource Methodes
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell") as UITableViewCell!
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.item
        
        cell.accessoryType = item.check ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK - TableView Deligate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].changeCheck()
        svareToFile()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Item
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
            itemArray.append(Item(text))
            svareToFile()
        }
    }
    
    //MARK - From File methodes
    func svareToFile(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilPath!)
        } catch {
            print("Error ecoding item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilPath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding items array: \(error)")
            }
        }
    }
    
}


