//
//  ProverbVC.swift
//  Lugat
//
//  Created by mehmet on 26.09.2021.
//  Copyright © 2021 my. All rights reserved.
//

import UIKit

class ProverbVC: UIViewController {
    
    var proverb: String = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var btnShare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnShare.layer.borderWidth = 1
        btnShare.layer.borderColor = UIColor.secondarySystemFill.cgColor
        btnShare.layer.cornerRadius = 10
        btnShare.layer.masksToBounds = true
        
        lblDescription.text = ""
        
        spinner.startAnimating()
        spinner.isHidden = false
        
        lblTitle.text = proverb
        
        let kelime = Utils.GetItem(wanted: proverb)
        
        // Populate UI
        DispatchQueue.main.async {
            
            let anlam = kelime![0].anlamlarListe?[0]

            let attributedString = NSMutableAttributedString()
            let attr: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18),
            ]
            let attrString = NSMutableAttributedString(string: "\(anlam!.anlam ?? "")", attributes: attr)
            attributedString.append(attrString)
            
            if let ornekler = anlam?.orneklerListe {
                for ornek in ornekler {
                    if let orn = ornek.ornek {

                        let attr: [NSAttributedString.Key: Any] = [
                            .font: UIFont.italicSystemFont(ofSize: 17),
                        ]
                        let attrString = NSMutableAttributedString(string: "\n\n\"\(orn)\"", attributes: attr)
                        
                        if let yazar = ornek.yazar {
                            if yazar.count > 0 {
                                let attr: [NSAttributedString.Key: Any] = [
                                    .font: UIFont.boldSystemFont(ofSize: 17)
                                ]
                                let attrStringYazar = NSMutableAttributedString(string: "\n \(yazar[0].tam_adi ?? "")", attributes: attr)
                                attrString.append(attrStringYazar)
                            }
                        }
                        attributedString.append(attrString)
                    }
                }
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 2
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            self.spinner.isHidden = true
            self.lblDescription.attributedText = attributedString
            self.lblDescription.sizeToFit()
        }
    }
    
    @IBAction func share(_ sender: Any) {        
        let activityVC = UIActivityViewController(activityItems: [proverb], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}
