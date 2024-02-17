//
//  AppTextFieldStyle.swift
//
//
//  Created by Dmytro Chumakov on 17.02.2024.
//

import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .frame(height: 44)
            .padding(.horizontal, 16)
            .font(.system(size: 20, weight: .regular))
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}
