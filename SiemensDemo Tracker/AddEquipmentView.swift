////  AddEquipmentView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 10/08/24.

// AddEquipmentView.swift
// SiemensDemo Tracker

import SwiftUI

struct AddEquipmentView: View {
    @Environment(\.presentationMode) var presentationMode
    var onSave: (Equipment) -> Void
    
    @State private var name = ""
    @State private var partNumber = ""
    @State private var assetNumber = ""
    @State private var responsible = ""
    @State private var status = EquipmentStatus.available
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información del Equipo")) {
                    TextField("Nombre del equipo", text: $name)
                    TextField("Número de Parte", text: $partNumber)
                    TextField("Número de Activo Fijo", text: $assetNumber)
                    TextField("Responsable", text: $responsible)
                }
                
                Section(header: Text("Estado")) {
                    Picker("Estado", selection: $status) {
                        ForEach(EquipmentStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            .navigationBarTitle("Agregar Equipo", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveEquipment()
                }
            )
        }
    }
    
    func saveEquipment() {
        let newEquipment = Equipment(
            name: name,
            partNumber: partNumber,
            assetNumber: assetNumber,
            responsible: responsible,
            status: status,
            reservations: []
        )
        
        onSave(newEquipment)
        presentationMode.wrappedValue.dismiss()
    }
}
