//
//  ScaleButtonStyle.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/9.
//

import Foundation
import SwiftUI

// 按钮点击效果
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
