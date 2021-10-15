//
//  ViewController.swift
//  Lugat
//
//  Created by mehmet on 29.11.2019.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UITextFieldDelegate {
    
    var dataAutoComplete = [String]()
    var filteredData = [String]()
    var selected = ""
    
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Lügat"
        
        self.hideKeyboard()
        getDataAutoComplete()
        search.becomeFirstResponder()
        search.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.reloadData()
    }
    
    @IBAction func ara(_ sender: UITextField) {
        
        if let wanted = sender.text {
            if wanted.count > 1 {
                filteredData = searchInList(wanted: wanted, list: self.dataAutoComplete)
            }
            else {
                filteredData = []
            }
        }
        tableView.reloadData()
    }
    
    fileprivate func getDataAutoComplete() {
        do {
            if let bundlePath = Bundle.main.path(forResource: "autocomplete", ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                if let array = json as? [String] {
                    dataAutoComplete = array
                }
            }
        } catch {
            print(error)
        }
    }
    
    fileprivate func searchInList(wanted: String, list: [String]) -> [String] {
        var results = [String]()
        if list.count > 0 {
            results = list.filter { item in
                return item.lowercased().starts(with: wanted.lowercased())
            }
            results = results.uniqued()
            
            if results.count > 10 {
                return Array(results[...10])
            }
        }
        return  results
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsSegue",
           let destination = segue.destination as? DetailViewController,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let selected = filteredData[indexPath.row]
            destination.title = selected
            
            search.text = selected
        }
    }
}

extension UIViewController
{
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hideKeyboard()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
