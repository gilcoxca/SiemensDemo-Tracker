//  EquipmentDetailView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 11/08/24.
//

import SwiftUI

struct EquipmentDetailView: View {
    @Binding var equipment: Equipment
    var onUpdate: (Equipment) -> Void
    var onDelete: (Equipment) -> Void
    
    @State private var showingReservationView = false
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 100))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(equipment.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    DetailRow(title: "Número de Parte", value: equipment.partNumber)
                    DetailRow(title: "Número de Activo", value: equipment.assetNumber)
                    DetailRow(title: "Responsable", value: equipment.responsible)
                    DetailRow(title: "Estado", value: equipment.status.rawValue)
                }
                
                if !equipment.reservations.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Reservaciones")
                            .font(.headline)
                        ForEach(equipment.reservations) { reservation in
                            Text("\(formatDate(reservation.startDate)) - \(formatDate(reservation.endDate))")
                                .font(.subheadline)
                        }
                    }
                }
                
                Button(action: {
                    showingReservationView = true
                }) {
                    Text("Reservar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top)
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Text("Eliminar Equipo")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Detalles del Equipo")
        .navigationBarItems(trailing: Button("Editar") {
            showingEditView = true
        })
        .sheet(isPresented: $showingReservationView) {
            ReservationView(equipment: $equipment)
        }
        .sheet(isPresented: $showingEditView) {
            EditEquipmentView(equipment: $equipment, onUpdate: onUpdate)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Eliminar Equipo"),
                message: Text("¿Estás seguro de que quieres eliminar \(equipment.name)?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    onDelete(equipment)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
    }
}
