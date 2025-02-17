//
//  CustomButton.swift
//  Recipe
//
//  Created by Geri-Das, Preman on 16/02/2025.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(background)
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
            }
        })
    }
}

#Preview {
    CustomButton(title: "Value", background: .pink, action: {
        print("Value")
    })
}
