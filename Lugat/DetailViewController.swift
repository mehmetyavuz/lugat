//
//  DetailViewController.swift
//  Lugat
//
//  Created by mehmet on 22.09.2021.
//  Copyright © 2021 my. All rights reserved.
//

import UIKit
import SQLite3


class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnRefresh: UIButton!
    
    var kelimeler:[madde] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
//        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableView.automaticDimension
 
        fetchData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        fetchData()
    }
    
    fileprivate func fetchData() {
        let aranan = self.title!
        if aranan != "" {
            self.spinner.startAnimating()
            self.btnRefresh.isHidden = true
            
            kelimeler = Utils.GetItem(wanted: aranan)!
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate, CustomCellDelegator {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return kelimeler.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CardView
        cell?.delegate = self
        cell?.configure(anlamlarListesi: kelimeler[indexPath.section].anlamlarListe!, atasozleri: kelimeler[indexPath.section].atasozu ?? [])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kelimeler[section].lisan!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let titleView = view as! UITableViewHeaderFooterView
        titleView.textLabel?.text =  kelimeler[section].lisan!
    }
    
    //MARK: - CustomCellDelegator Methods
    
    func callSegueFromCell(data proverbs: [atasozu]) {
      //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegue(withIdentifier: "segueProverbs", sender:proverbs )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueProverbs",
           let destination = segue.destination as? ProverbsViewController,
           let proverbs = sender as? [atasozu] {
            destination.proverbs = proverbs
        }
    }
}

protocol CustomCellDelegator {
    func callSegueFromCell(data proverbs: [atasozu])
}

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}
