//
//  chatView.swift
//  aimicus
//
//  Created by Thomas on 09.06.26.
//

import SwiftUI

struct AnswerView: View {
    
    
    @State private var aktuelleDrehung: Double = 0.0
    
    var show:Bool
    
    var outTxt:AttributedString


    var body: some View {
    
        
        ScrollView {
            
            if show {
                withAnimation{
                    Text(outTxt)
                }
            }
            
            else {
                Image(systemName: "circle.hexagonpath.fill")
                    .font(.largeTitle)
                    .rotationEffect(.degrees(aktuelleDrehung))
                    .onAppear {
                        withAnimation(
                            .linear(duration: 2)
                            .repeatForever(autoreverses: false)
                        ) {
                            aktuelleDrehung = 360.0
                        }
                    }
            }
                    
        }
        .padding()
    }

}

#Preview {
    AnswerView(show: true, outTxt: "Hi")
}
