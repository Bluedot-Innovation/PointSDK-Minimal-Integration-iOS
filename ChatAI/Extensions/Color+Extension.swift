//
//  Color+Extension.swift
//  PointSDK-MinimalIntegrationExample-iOS
//
//  Created by Nataliia Klymenko on 11/12/2024.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import SwiftUICore

extension Color {
    
    private static func rgb(_ red: Int, _ green: Int, _ blue: Int) -> Color {
        Color(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: 1.0
        )
    }
    
    static let chatAIBackground = Color.rgb(242, 242, 247)
    static let chatAIAnswersBackground = Color.rgb(229, 230, 235)
}
