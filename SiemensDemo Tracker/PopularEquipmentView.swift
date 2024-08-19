//
//  Untitled.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 18/08/24.
//

import SwiftUI

struct PopularEquipmentView: View {
    let equipments: [Equipment]
    let onEquipmentSelected: (Equipment) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Equipos Populares")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(equipments) { equipment in
                        EquipmentCard(equipment: equipment)
                            .onTapGesture {
                                onEquipmentSelected(equipment)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct EquipmentCard: View {
    let equipment: Equipment

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "desktopcomputer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 100)
                .padding()

            Text(equipment.name)
                .font(.headline)

            Text(equipment.status.rawValue)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 150)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
