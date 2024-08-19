////  ReservationView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 10/08/24.
//

import SwiftUI
import Firebase

struct ReservationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var equipment: Equipment
    
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(3600) // Default to 1 hour later
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del Equipo")) {
                    Text(equipment.name)
                    Text("Número de Parte: \(equipment.partNumber)")
                    Text("Número de Activo: \(equipment.assetNumber)")
                }
                
                Section(header: Text("Fechas de Reservación")) {
                    DatePicker("Fecha de Inicio", selection: $startDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    DatePicker("Fecha de Fin", selection: $endDate, in: startDate..., displayedComponents: [.date, .hourAndMinute])
                }
            }
            .navigationBarTitle("Reservar Equipo", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Reservar") {
                    makeReservation()
                }
            )
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reservación"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                if !alertMessage.contains("Error") {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    func makeReservation() {
        // Check if the equipment is available
        if equipment.status != .available {
            alertMessage = "Este equipo no está disponible para reservar."
            showAlert = true
            return
        }
        
        // Check for overlapping reservations
        for reservation in equipment.reservations {
            if (startDate < reservation.endDate && endDate > reservation.startDate) {
                alertMessage = "Esta reservación se superpone con una existente."
                showAlert = true
                return
            }
        }
        
        // Create new reservation
        let newReservation = Reservation(startDate: startDate, endDate: endDate)
        equipment.reservations.append(newReservation)
        
        // Update equipment status
        equipment.status = .inUse
        
        // Update in Firestore
        let docRef = db.collection("equipment").document(equipment.id)
        docRef.setData(equipment.toDictionary()) { error in
            if let error = error {
                alertMessage = "Error al hacer la reservación: \(error.localizedDescription)"
            } else {
                alertMessage = "Reservación realizada con éxito."
            }
            showAlert = true
        }
    }
}

struct ReservationView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationView(equipment: .constant(Equipment(
            id: "1",
            name: "Equipo de Prueba",
            partNumber: "PT001",
            assetNumber: "AT001",
            responsible: "Juan Pérez",
            status: .available,
            reservations: []
        )))
    }
}
