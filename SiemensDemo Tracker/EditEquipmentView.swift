//  EditEquipmentView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 11/08/24.
//

import SwiftUI

struct EditEquipmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var equipment: Equipment
    var onUpdate: (Equipment) -> Void
    
    @State private var name: String
    @State private var partNumber: String
    @State private var assetNumber: String
    @State private var responsible: String
    @State private var status: EquipmentStatus
    
    init(equipment: Binding<Equipment>, onUpdate: @escaping (Equipment) -> Void) {
        self._equipment = equipment
        self.onUpdate = onUpdate
        
        _name = State(initialValue: equipment.wrappedValue.name)
        _partNumber = State(initialValue: equipment.wrappedValue.partNumber)
        _assetNumber = State(initialValue: equipment.wrappedValue.assetNumber)
        _responsible = State(initialValue: equipment.wrappedValue.responsible)
        _status = State(initialValue: equipment.wrappedValue.status)
    }
    
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
            .navigationBarTitle("Editar Equipo", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveChanges()
                }
            )
        }
    }
    
    func saveChanges() {
        equipment.name = name
        equipment.partNumber = partNumber
        equipment.assetNumber = assetNumber
        equipment.responsible = responsible
        equipment.status = status
        
        onUpdate(equipment)
        presentationMode.wrappedValue.dismiss()
    }
}
