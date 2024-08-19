////  ContentView.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 10/08/24.
//


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var searchText = ""
    @State private var showingAddEquipmentView = false
    @State private var showingReservationView = false
    @State private var selectedEquipmentID: String?
    @State private var equipmentToDelete: Equipment?
    @State private var isAuthenticated = false

    @State private var equipmentItems: [Equipment] = []

    private let db = Firestore.firestore()

    let categories = ["S7", "ET 200", "WinCC", "Motion Control"]

    var body: some View {
        Group {
            if isAuthenticated {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("SiemensDemo Tracker")
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Buscar")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)

                            SearchBar(text: $searchText)

                            CategoryView(categories: categories)

                            PopularEquipmentView(equipments: filteredEquipments, onEquipmentSelected: { equipment in
                                selectedEquipmentID = equipment.id
                            })
                        }
                        .padding()
                    }
                    .background(Color(UIColor.systemBackground))
                    .navigationBarItems(trailing:
                        HStack {
                            Button(action: { showingAddEquipmentView = true }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                            }
                            Button(action: { showingReservationView = true }) {
                                Image(systemName: "calendar.badge.plus")
                                    .foregroundColor(.blue)
                            }
                            Button(action: signOut) { // Botón de Cerrar Sesión
                                Image(systemName: "person.crop.circle.badge.xmark")
                                    .foregroundColor(.red)
                            }
                        }
                    )
                    .sheet(isPresented: $showingAddEquipmentView) {
                        AddEquipmentView(onSave: saveEquipment)
                    }
                    .sheet(item: Binding<Equipment?>(
                        get: { selectedEquipmentID.flatMap { id in equipmentItems.first(where: { $0.id == id }) } },
                        set: { equipment in
                            selectedEquipmentID = equipment?.id
                        }
                    )) { equipment in
                        EquipmentDetailView(
                            equipment: binding(for: equipment),
                            onUpdate: updateEquipment,
                            onDelete: deleteEquipment
                        )
                    }
                    .sheet(isPresented: $showingReservationView) {
                        EquipmentListView(equipments: filteredEquipments, onEquipmentSelected: { equipment in
                            selectedEquipmentID = equipment.id
                        })
                    }
                }
            } else {
                LoginView(onLoginSuccess: {
                    isAuthenticated = true
                    fetchEquipment()
                })
            }
        }
        .onAppear {
            isAuthenticated = Auth.auth().currentUser != nil
            if isAuthenticated {
                fetchEquipment()
            }
        }
    }

    var filteredEquipments: [Equipment] {
        if searchText.isEmpty {
            return equipmentItems
        } else {
            return equipmentItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    func fetchEquipment() {
        db.collection("equipment").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching equipment: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }

            self.equipmentItems = documents.compactMap { Equipment(document: $0) }
        }
    }

    func saveEquipment(_ equipment: Equipment) {
        let docRef = db.collection("equipment").document()
        docRef.setData(equipment.toDictionary()) { error in
            if let error = error {
                print("Error saving equipment: \(error.localizedDescription)")
            } else {
                print("Equipment saved successfully")
                fetchEquipment()  // Refresh the list after saving
            }
        }
    }

    func updateEquipment(_ equipment: Equipment) {
        let docRef = db.collection("equipment").document(equipment.id)
        docRef.setData(equipment.toDictionary()) { error in
            if let error = error {
                print("Error updating equipment: \(error.localizedDescription)")
            } else {
                print("Equipment updated successfully")
                fetchEquipment()  // Refresh the list after updating
            }
        }
    }

    func deleteEquipment(_ equipment: Equipment) {
        db.collection("equipment").document(equipment.id).delete { error in
            if let error = error {
                print("Error deleting equipment: \(error.localizedDescription)")
            } else {
                print("Equipment deleted successfully")
                fetchEquipment()  // Refresh the list after deleting
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    private func binding(for equipment: Equipment) -> Binding<Equipment> {
        Binding<Equipment>(
            get: { equipment },
            set: { newValue in
                if let index = equipmentItems.firstIndex(where: { $0.id == newValue.id }) {
                    equipmentItems[index] = newValue
                }
            }
        )
    }
}
