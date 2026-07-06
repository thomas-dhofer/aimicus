//
//  aimicusApp.swift
//  aimicus
//
//  Created by Thomas Dornhofer on 24.03.26.
//

import SwiftUI

@main
struct aimicusApp: App {

    var body: some Scene {
        
            MenuBarExtra("aimicus", systemImage: "circle.hexagonpath.fill") {
                
            VStack(){
                            
                chatBubbleView()
                    
            }
            .padding(10)
            .background(.ultraThinMaterial)

                
        }
            .menuBarExtraStyle(.window)

    }
    
}
