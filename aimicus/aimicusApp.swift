//
//  aimicusApp.swift
//  aimicus
//
//  Created by Thomas on 24.03.26.
//

import SwiftUI

@main
struct aimicusApp: App {

    var body: some Scene {
        
            MenuBarExtra("aimicus", systemImage: "circle.hexagonpath.fill") {
                
            VStack(){
                            
                ChatView()
                    
            }
            .padding(10)
            .background(.ultraThinMaterial)
            
        }
            .menuBarExtraStyle(.window)

    }
    
}
