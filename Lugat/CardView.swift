//
//  CardView.swift
//  Lugat
//
//  Created by mehmet on 23.09.2021.
//  Copyright © 2021 my. All rights reserved.
//

import UIKit


class CardView: UITableViewCell {
    
    var delegate:CustomCellDelegator!
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var lblAnlam: UILabel!
    @IBOutlet weak var btnProverb: UIButton!
    
//    @IBOutlet weak var constraintLblBottom: NSLayoutConstraint!
    
    var _atasozleri: [atasozu]?
    
    func configure(anlamlarListesi: [anlam], atasozleri: [atasozu]?) {
        
        let attributedString = NSMutableAttributedString()
        
        for (i, anlam) in anlamlarListesi.enumerated() {
            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
            var attrString = (i == 0) ? NSMutableAttributedString(string: "\(i+1). ", attributes: attr) : NSMutableAttributedString(string: "\n\n\(i+1). ", attributes: attr)
            attributedString.append(attrString)
            
            if let ozListe = anlam.ozelliklerListe {
                if ozListe.count > 0 {
                    var ozellikler: [String] = []
                    for ozellik in anlam.ozelliklerListe! {
                        ozellikler.append(ozellik.tam_adi!)
                    }
                    let ozelliklerString = ozellikler.joined(separator: ", ")
                    let attr: [NSAttributedString.Key: Any] = [
                        .font: UIFont.italicSystemFont(ofSize: 15),
                        .foregroundColor: UIColor.systemOrange
                    ]
                    attrString = NSMutableAttributedString(string: "\(ozelliklerString) ", attributes: attr)
                    attributedString.append(attrString)
                }
            }
            if let anlm = anlam.anlam {
                let attr: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                let attrString = NSMutableAttributedString(string: "\(anlm)", attributes: attr)
                attributedString.append(attrString)
            }
            if let ornekler = anlam.orneklerListe {
                for ornek in ornekler {
                    if let orn = ornek.ornek {
                        let attr: [NSAttributedString.Key: Any] = [
                            .font: UIFont.italicSystemFont(ofSize: 15)
                        ]
                        let attrString = NSMutableAttributedString(string: "\n\"\(orn)\"", attributes: attr)
                        
                        if let yazar = ornek.yazar {
                            if yazar.count > 0 {
                                let attr: [NSAttributedString.Key: Any] = [
                                    .font: UIFont.boldSystemFont(ofSize: 15)
                                ]
                                let attrStringYazar = NSMutableAttributedString(string: "\n \(yazar[0].tam_adi ?? "")", attributes: attr)
                                attrString.append(attrStringYazar)
                            }
                        }
                        attributedString.append(attrString)
                    }
                }
            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        lblAnlam.attributedText = attributedString
        lblAnlam.sizeToFit()
        
        if atasozleri!.count > 0 {
            _atasozleri = atasozleri

            btnProverb.layer.borderWidth = 1
            btnProverb.layer.borderColor = UIColor.secondarySystemFill.cgColor
            btnProverb.layer.cornerRadius = 10
            btnProverb.layer.masksToBounds = true
            
            btnProverb.isHidden = false
            lblAnlam.bottomAnchor.constraint(equalTo: btnProverb.topAnchor, constant: -20.0).isActive = true            
        }
        else {
            btnProverb.isHidden = true
            lblAnlam.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true
        }
        cardView.updateConstraints()
    }
    
    @IBAction func atasozleriniGetir(_ sender: Any) {
        if(self.delegate != nil) { //Just to be safe.
            self.delegate.callSegueFromCell(data: _atasozleri ?? [])
        }
    }
}
