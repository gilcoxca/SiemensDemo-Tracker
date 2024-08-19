//  EquipmentListView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 11/08/24.
//

import SwiftUI

struct EquipmentListView: View {
    @State private var searchText = ""
    var equipments: [Equipment]
    var onEquipmentSelected: (Equipment) -> Void

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)

                List(filteredEquipments) { equipment in
                    EquipmentRow(equipment: equipment)
                        .onTapGesture {
                            onEquipmentSelected(equipment)
                        }
                }
            }
            .navigationBarTitle("Equipos Disponibles")
        }
    }

    var filteredEquipments: [Equipment] {
        if searchText.isEmpty {
            return equipments
        } else {
            return equipments.filter { equipment in
                equipment.name.lowercased().contains(searchText.lowercased()) ||
                equipment.partNumber.lowercased().contains(searchText.lowercased()) ||
                equipment.assetNumber.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct EquipmentRow: View {
    var equipment: Equipment

    var body: some View {
        VStack(alignment: .leading) {
            Text(equipment.name)
                .font(.headline)
            Text("Parte: \(equipment.partNumber)")
                .font(.subheadline)
            Text("Activo: \(equipment.assetNumber)")
                .font(.subheadline)
            Text("Estado: \(equipment.status.rawValue)")
                .font(.subheadline)
                .foregroundColor(statusColor(for: equipment.status))
        }
    }

    func statusColor(for status: EquipmentStatus) -> Color {
        switch status {
        case .available:
            return .green
        case .inUse:
            return .blue
        case .inMaintenance:
            return .orange
        case .damaged:
            return .red
        }
    }
}

