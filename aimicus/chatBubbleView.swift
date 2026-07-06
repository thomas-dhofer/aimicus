//
//  chatBubbleView.swift
//  aimicus
//
//  Created by Thomas Dornhofer on 08.06.26.
//

import SwiftUI
import Foundation

struct chatBubbleView: View {
    
    @State var question = ""
        
    @State private var isPresented = false
    
    @State private var answer:AttributedString = ""
    
    @State var show = false
    
    @State var disabled = false
    
    @State var eyesClosed = false

    var body: some View {
            
        HStack{
            
            TextField("Ask me...", text: $question, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .frame(minHeight: 44)
                .background(
                    Color.clear
                        .contentShape(Rectangle())
                )
                .glassEffect()

            
            
            Button{
                if isPresented == true{
                    isPresented = false
                }
                
                else{
                    show = false
                    let trimmed = question.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    
                    Task{
                        disabled = true
                        answer = await OllamaService.sendToOllama(trimmed)

                        
                        if answer != "" {
                            show = true
                            disabled = false
                        }
                    }
                                    
                    question = ""

                    withAnimation {
                        isPresented = true
                    }
                }
            }label: {
                if isPresented == true{
                    Image(systemName: "xmark")
                        .padding()
                        .contentShape(Rectangle())
                        .glassEffect()


                }
                else{
                    Image(systemName: "checkmark")
                        .padding()
                        .contentShape(Rectangle())
                        .glassEffect()


                }
            }
            .buttonStyle(.plain)
            .disabled(disabled)
        }
        .frame(width: 400)
        .popover(isPresented: $isPresented, arrowEdge: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    chatView(show: show, outTxt: answer)
                        .frame(width: 400)
                        .frame(maxHeight: 600)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                }
            }
            .interactiveDismissDisabled(true)
            .presentationSizing(.fitted)
        }
    }
}

#Preview {
    chatBubbleView()
}

