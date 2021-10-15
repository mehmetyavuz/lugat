//
//  Model.swift
//  Lugat
//
//  Created by mehmet on 2.12.2019.
//  Copyright © 2019 my. All rights reserved.
//


struct madde: Codable {
    let madde_id: Int32
    let madde: String?
    var cogul_mu: Int32?
    let ozel_mi: Int32?
    let lisan: String?
    let telaffuz: String?
    let birlesikler: String?
    var anlamlarListe: [anlam]?
    var atasozu: [atasozu]?
}

struct anlam: Codable {
    let anlam_id: Int32
    let madde_id: Int32
    let anlam_sira: Int32?
    let anlam: String?
    var orneklerListe: [ornek]?
    var ozelliklerListe: [ozellik]?
}

struct ornek: Codable {
    let ornek_id: Int32
    let anlam_id: Int32
    let ornek_sira: Int32?
    let ornek: String?
    let yazar_id: Int32
    var yazar: [yazar]?
}

struct yazar: Codable {
    let yazar_id: Int32
    let tam_adi: String?
    let kisa_adi: String?
}

struct ozellik: Codable {
    let ozellik_id: Int32
    let tam_adi: String?
    let kisa_adi: String?
}

struct atasozu: Codable {
    let madde_id: Int32
    let madde: String?
}
