//
//  ButtonStyle.swift
//  Photo
//
//  Created by Dano on 02.10.23.
//

import SwiftUI


struct CustomButtonStyle: ButtonStyle {
    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isHovered ? Color.white : Color.white, lineWidth: 2)
                    .background(isHovered ? Color.white : Color.clear)
                    .cornerRadius(20)
            )
            .foregroundColor(isHovered ? Color.blue : Color.white)
            .onHover { hovering in
                self.isHovered = hovering
            }
    }
}
