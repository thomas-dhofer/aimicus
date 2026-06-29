//
//  aimicusApp.swift
//  aimicus
//
//  Created by Thomas Dornhofer on 24.03.26.
//

import SwiftUI

@main
struct aimicusApp: App {
    
    @State var eyesClosed = false
    @State var pupilOffset = 0.0

    var body: some Scene {
        
            MenuBarExtra("aimicus", systemImage: "circle.hexagonpath.fill") {
            VStack(){
                                
                HStack{
                
                    Image("body")
                        .padding()
                        .overlay {
                            Image("eyes")
                                .scaleEffect(x: 1.0, y: eyesClosed ? 0.0 : 1.0, anchor: .center)
                                .animation(.easeInOut(duration: 0.15), value: eyesClosed)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                                        eyesClosed = true
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            eyesClosed = false
                                        }
                                    }
                                }
                                .overlay{
                                    Image("pupills")
                                }
                        }
                    
                    Spacer()
                }
                
                
                Divider()
                
                
                chatBubbleView()
                    
            }
            .padding(10)
            .background(.ultraThinMaterial)
                
        }
        .menuBarExtraStyle(.window)
    }
    
}
