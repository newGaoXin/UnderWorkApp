//
//  PreviewProvider.swift
//  UnderWorkApp
//
//  Created by newgaoxin on 2025/2/9.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev : DevelopmentPreviewProvider {
        return DevelopmentPreviewProvider.instance
    }
}


struct DevelopmentPreviewProvider {
    
    static let  instance  = DevelopmentPreviewProvider()
    
    private init() {
    }
    
}
