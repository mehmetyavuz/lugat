//
//  Helper.swift
//  Lugat
//
//  Created by mehmet on 26.09.2021.
//  Copyright © 2021 my. All rights reserved.
//

import Foundation
import SQLite3


class Utils {
    
    static func GetItem(wanted: String) -> [madde]? {
        var result:[madde] = []
        
        let bundlePath = Bundle.main.path(forResource: "gts", ofType: "sqlite3")
        var db: OpaquePointer?
        guard sqlite3_open(bundlePath, &db) == SQLITE_OK else {
            print("error opening database")
            sqlite3_close(db)
            db = nil
            return nil
        }
        
        let search = wanted.replacingOccurrences(of: "'", with: "''")
        var queryString = "SELECT * FROM madde WHERE madde LIKE '\(search)'"
        var stmt:OpaquePointer = CheckQuery(db: db, queryString: queryString)!
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let mdde = sqlite3_column_text(stmt, 6) == nil ? "" : String(cString: sqlite3_column_text(stmt, 6))
            let cogul = sqlite3_column_int(stmt, 10)
            let ozel = sqlite3_column_int(stmt, 11)
            let lisan = String(cString: sqlite3_column_text(stmt, 13))
            let telaffuz = sqlite3_column_text(stmt, 14) == nil ? "" : String(cString: sqlite3_column_text(stmt, 14))
            let birlesik = sqlite3_column_text(stmt, 15) == nil ? "" : String(cString: sqlite3_column_text(stmt, 15))
            
            let md = madde(madde_id: id, madde: mdde, cogul_mu: cogul, ozel_mi: ozel, lisan: lisan, telaffuz: telaffuz, birlesikler: birlesik, anlamlarListe: nil, atasozu: nil)
            
            result.append(md)
        }
        
        for (i,klm) in result.enumerated() {
            
            /// ATASÖZLERİ
            queryString = "SELECT * FROM atasozu WHERE madde_id IN (SELECT atasozu_madde_id FROM madde_atasozu WHERE madde_id = '\(String(klm.madde_id))')"
            
            stmt = CheckQuery(db: db, queryString: queryString)!

            var atasozleri: [atasozu] = []
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                let id = sqlite3_column_int(stmt, 0)
                let md = sqlite3_column_text(stmt, 1) == nil ? "" : String(cString: sqlite3_column_text(stmt, 1))
                
                let proverb = atasozu(madde_id: id, madde: md)
                atasozleri.append(proverb)
            }
            result[i].atasozu = atasozleri
            
            /// ANLAMLAR
            queryString = "SELECT * FROM anlam WHERE madde_id = '\(String(klm.madde_id))'"
            stmt = CheckQuery(db: db, queryString: queryString)!

            var anlamlar: [anlam] = []
            while(sqlite3_step(stmt) == SQLITE_ROW) {
                
                let anlam_id = sqlite3_column_int(stmt, 0)
                let madde_id = sqlite3_column_int(stmt, 1)
                let anlam_sira = sqlite3_column_int(stmt, 2)
                let anlm = sqlite3_column_text(stmt, 5) == nil ? "" : String(cString: sqlite3_column_text(stmt, 5))
                
                let anlam = anlam(anlam_id: anlam_id, madde_id: madde_id, anlam_sira: anlam_sira, anlam: anlm, orneklerListe: nil, ozelliklerListe: nil)
                anlamlar.append(anlam)
            }
            
            
            for (j, anlm) in anlamlar.enumerated() {
                
                /// ORNEKLER
                queryString = "SELECT * FROM ornek WHERE anlam_id = '\(String(anlm.anlam_id))'"
                stmt = CheckQuery(db: db, queryString: queryString)!

                var ornekler: [ornek] = []
                while(sqlite3_step(stmt) == SQLITE_ROW) {
                    
                    let ornek_id = sqlite3_column_int(stmt, 0)
                    let anlam_id = sqlite3_column_int(stmt, 1)
                    let ornek_sira = sqlite3_column_int(stmt, 2)
                    let ornk = sqlite3_column_text(stmt, 3) == nil ? "" : String(cString: sqlite3_column_text(stmt, 3))
                    let yazar_id = sqlite3_column_int(stmt, 5)
                    
                    let orn = ornek(ornek_id: ornek_id, anlam_id: anlam_id, ornek_sira: ornek_sira, ornek: ornk, yazar_id: yazar_id, yazar: nil)
                    ornekler.append(orn)
                }
                
                /// YAZARLAR
                for (k, orn) in ornekler.enumerated() {
                    queryString = "SELECT * FROM yazar WHERE yazar_id = '\(String(orn.yazar_id))'"
                    stmt = CheckQuery(db: db, queryString: queryString)!
                    
                    var yazarlar: [yazar] = []
                    while(sqlite3_step(stmt) == SQLITE_ROW) {
                        
                        let yazar_id = sqlite3_column_int(stmt, 0)
                        let tam_adi = sqlite3_column_text(stmt, 1) == nil ? "" : String(cString: sqlite3_column_text(stmt, 1))
                        let kisa_adi = sqlite3_column_text(stmt, 2) == nil ? "" : String(cString: sqlite3_column_text(stmt, 2))
                        
                        let yzr = yazar(yazar_id: yazar_id, tam_adi: tam_adi, kisa_adi: kisa_adi)
                        yazarlar.append(yzr)
                    }
                    
                    ornekler[k].yazar = yazarlar
                }
                anlamlar[j].orneklerListe = ornekler
                
                /// OZELLIKLER
                queryString = "SELECT * FROM ozellik WHERE ozellik_id IN (SELECT anlam_ozellik.ozellik_id FROM anlam_ozellik WHERE anlam_id = '\(String(anlm.anlam_id))')"
                stmt = CheckQuery(db: db, queryString: queryString)!
                
                var ozellikler: [ozellik] = []
                while(sqlite3_step(stmt) == SQLITE_ROW) {
                    
                    let ozl_id = sqlite3_column_int(stmt, 0)
                    let tam_adi = sqlite3_column_text(stmt, 2) == nil ? "" : String(cString: sqlite3_column_text(stmt, 2))
                    let kisa_adi = sqlite3_column_text(stmt, 3) == nil ? "" : String(cString: sqlite3_column_text(stmt, 3))
                    
                    let ozl = ozellik(ozellik_id: ozl_id, tam_adi: tam_adi, kisa_adi: kisa_adi)
                    ozellikler.append(ozl)
                }
                anlamlar[j].ozelliklerListe = ozellikler
            }
            result[i].anlamlarListe = anlamlar
        }
        
        return result
    }
    
    fileprivate static func CheckQuery(db: OpaquePointer?, queryString: String) -> OpaquePointer? {
        
        //statement pointer
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing query: \(errmsg)")
            return nil
        }
        
        return stmt!
    }
    
//    static func UrlString(txt: String) -> String {
//        var result =  txt.lowercased()
//        result = result.replacingOccurrences(of: "ç", with: "%C3%A7")
//        result = result.replacingOccurrences(of: "ğ", with: "%C4%9F")
//        result = result.replacingOccurrences(of: "ö", with: "%C3%B6")
//        result = result.replacingOccurrences(of: "ş", with: "%C5%9F")
//        result = result.replacingOccurrences(of: "ü", with: "%C3%BC")
//        result = result.replacingOccurrences(of: "â", with: "%C3%A2")
//        result = result.replacingOccurrences(of: "î", with: "%C3%AE")
//        result = result.replacingOccurrences(of: "û", with: "%C3%BB")
//        result = result.replacingOccurrences(of: "ı", with: "%C4%B1")
//        result = result.replacingOccurrences(of: " ", with: "%20")
//        return result
//    }
    
//            guard let url = URL(string: "https://sozluk.gov.tr/gts?ara=\(aranan)") else { return }
//            URLSession.shared.dataTask(with: url) { (result) in
//
//                switch result {
//                case .success((let response, let data)):
//                    print("response : \(response)")
//
//                    do {
//                        self.kelimeler = try JSONDecoder().decode([Kelime].self, from: data)
//
//                        // You should never access any UI from background threads,
//                        // you must do it from the main thread, to do this you may use gcd:
//                        DispatchQueue.main.async {
//                            self.spinner.stopAnimating()
//                            self.tableView.isHidden = false
//                            self.tableView.reloadData()
//                        }
//
//                    } catch let error {
//                        print(error)
//                        DispatchQueue.main.async {
//                            self.spinner.stopAnimating()
//                            self.tableView.isHidden = true
//                            self.btnRefresh.isHidden = false
//                        }
//                    }
//
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print(jsonString)
//                    }
//                    break
//                case .failure(let error):
//                    print(error)
//                    DispatchQueue.main.async {
//                        self.spinner.stopAnimating()
//                        self.tableView.isHidden = true
//                        self.btnRefresh.isHidden = false
//                    }
//                    break
//                }
//            }.resume()
}
