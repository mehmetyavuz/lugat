//
//  ProverbsTableViewCell.swift
//  Lugat
//
//  Created by mehmet on 25.09.2021.
//  Copyright © 2021 my. All rights reserved.
//

import UIKit

class ProverbsViewController: UIViewController {
    
    var proverbs: [atasozu] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Atasözleri & Deyimler"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueProverb",
           let destination = segue.destination as? ProverbVC,
           let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let selected = proverbs[indexPath.row]
            destination.proverb = selected.madde!
        }
    }
}

extension ProverbsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proverbs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellProverb", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). \(proverbs[indexPath.row].madde ?? "")"
        let imgView = UIImageView(image: UIImage(systemName: "chevron.up"))
        imgView.tintColor = .systemGray
        imgView.sizeToFit()
        cell.accessoryView = imgView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
