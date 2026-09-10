//
//  chatBubbleView.swift
//  aimicus
//
//  Created by Thomas on 08.06.26.
//

import SwiftUI
import Foundation

struct ChatView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var question = ""
        
    @State private var isPresented = false
    
    @State private var answer:AttributedString = ""
    
    @State var show = false
    
    @State var disabled = false
    
    @State var model = ""
    
    @State var models: [String] = []

    var body: some View {
            
        VStack{
            
            HStack{
                
                Menu {
                    ForEach(models, id: \.self) { model in
                        Button(model) {
                            self.model = model
                        }
                    }
                } label: {
                    Text(model)
                }
                .task {
                    do{
                        models = try await OllamaModelService.fetchOllamaModels()
                    }
                    
                    catch{
                        models = ["Kein Modell gefunden"]
                    }
                    
                }
                
                Spacer()
            }
            
            TextEditor(text: $question)
                .textEditorStyle(.plain)
                .frame(maxHeight: .infinity)
                .font(.system(size: 12))
                .lineSpacing(4)
                .padding(10)
                .glassEffect(in: RoundedRectangle(cornerRadius: 16))
                .foregroundStyle(.primary)
                
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
                        answer = await OllamaAPIService.sendToOllama(text: trimmed, model: model)

                        
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
                        .frame(maxWidth: .infinity)
                        .background(
                            colorScheme == .dark ? .white : .black
                        )
                        .foregroundStyle(
                            colorScheme == .light ? .white : .black
                        )
                        .glassEffect()
                        .contentShape(Rectangle())
                        .cornerRadius(20)
                }
                
                else{
                    Image(systemName: "checkmark")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            colorScheme == .dark ? .white : .black
                        )
                        .foregroundStyle(
                            colorScheme == .light ? .white : .black
                        )
                        .foregroundStyle(.primary)
                        .glassEffect()
                        .contentShape(Rectangle())
                        .cornerRadius(20)
                }
            }
            .buttonStyle(.plain)
            .disabled(disabled)
        }
        .frame(width: 400,height: 200)
        .popover(isPresented: $isPresented, arrowEdge: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    AnswerView(show: show, outTxt: answer)
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
    ChatView()
}

