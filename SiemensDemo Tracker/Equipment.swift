//  Equipment.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 10/08/24.
//

import Foundation
import Firebase

struct Equipment: Identifiable {
    var id: String
    var name: String
    var partNumber: String
    var assetNumber: String
    var responsible: String
    var status: EquipmentStatus
    var reservations: [Reservation]
    
    init(id: String = UUID().uuidString, name: String, partNumber: String, assetNumber: String, responsible: String, status: EquipmentStatus, reservations: [Reservation]) {
        self.id = id
        self.name = name
        self.partNumber = partNumber
        self.assetNumber = assetNumber
        self.responsible = responsible
        self.status = status
        self.reservations = reservations
    }
    
    init?(document: DocumentSnapshot) {
        guard
            let data = document.data(),
            let name = data["name"] as? String,
            let partNumber = data["partNumber"] as? String,
            let assetNumber = data["assetNumber"] as? String,
            let responsible = data["responsible"] as? String,
            let statusRawValue = data["status"] as? String,
            let status = EquipmentStatus(rawValue: statusRawValue),
            let reservationsData = data["reservations"] as? [[String: Any]]
        else {
            return nil
        }
        
        self.id = document.documentID
        self.name = name
        self.partNumber = partNumber
        self.assetNumber = assetNumber
        self.responsible = responsible
        self.status = status
        self.reservations = reservationsData.compactMap { Reservation(dictionary: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "partNumber": partNumber,
            "assetNumber": assetNumber,
            "responsible": responsible,
            "status": status.rawValue,
            "reservations": reservations.map { $0.toDictionary() }
        ]
    }
}

enum EquipmentStatus: String, CaseIterable {
    case available = "Disponible"
    case inUse = "En uso"
    case inMaintenance = "En mantenimiento"
    case damaged = "Dañado"
}

struct Reservation: Identifiable {
    let id: String
    var startDate: Date
    var endDate: Date
    
    init(id: String = UUID().uuidString, startDate: Date, endDate: Date) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let id = dictionary["id"] as? String,
            let startDate = (dictionary["startDate"] as? Timestamp)?.dateValue(),
            let endDate = (dictionary["endDate"] as? Timestamp)?.dateValue()
        else {
            return nil
        }
        
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate)
        ]
    }
}
