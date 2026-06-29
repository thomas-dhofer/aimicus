//
//  headerView.swift
//  aimicus
//
//  Created by Thomas Dornhofer on 29.06.26.
//

import SwiftUI

struct headerView: View {
    
    @State var eyesClosed = false
    @State var pupilOffset = 0.0
    
    var body: some View {
        
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
            
            Button{
                
            }label: {
                Image(systemName: "microphone.fill")
                    .padding()
                    .contentShape(Rectangle())
                    .glassEffect()
            }
            .buttonStyle(.plain)
            .padding(.vertical)
            
            Button{
                
            }label: {
                Image(systemName: "photo.badge.plus.fill")
                    .padding()
                    .contentShape(Rectangle())
                    .glassEffect()
            }
            .buttonStyle(.plain)
            .padding(.vertical)
            
        }
    }
}

#Preview {
    headerView()
}
