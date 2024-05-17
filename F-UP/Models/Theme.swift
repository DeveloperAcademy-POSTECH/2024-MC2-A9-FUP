//
//  Theme.swift
//  F-UP
//
//  Created by namdghyun on 5/17/24.
//

import SwiftUI

// MARK: - Color Pallete
struct Theme {
    static let white: Color = Color(hex: 0xFEFEFE)
    static let black: Color = Color(hex: 0x2D2F33)
    static let point: Color = Color(hex: 0x2DBBB3)
    
    static let semiblack: Color = Color(hex: 0x83888F)
    static let subblack: Color = Color(hex: 0xB9BECD)
    
    static let background: Color = Color(hex: 0xF7F7F9)
    static let shadow: Color = Color(hex: 0x8C8F9B)
    
    static let round: CGFloat = 12
    static let padding: CGFloat = 20
}


// MARK: - Custom Shadow View Modifier
struct DropShadow: ViewModifier {
    let opacity: Double
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Theme.shadow.opacity(opacity), radius: 8, x: 0, y: 0)
            .overlay(
                content
                    .shadow(color: Color.black.opacity(opacity), radius: 8, x: 0, y: 0)
                    .mask(content)
            )
    }
}

extension View {
    func dropShadow(opacity: Double) -> some View {
        self.modifier(DropShadow(opacity: opacity))
    }
}

// MARK: - Hex Color Extension
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
