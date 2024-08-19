//
//  Untitled.swift
//  SiemensDemo Tracker
//
//  Created by Gilberto Coxca on 18/08/24.
//

import SwiftUI

struct CategoryView: View {
    let categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
        }
    }
}
