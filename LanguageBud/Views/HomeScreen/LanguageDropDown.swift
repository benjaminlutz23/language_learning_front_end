//
//  LanguageDropDown.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/23/24.
//

import SwiftUI

struct DropdownView: View {
    let title: String
    let prompt: String
    let options: [String]
    @Binding var isExpanded: Bool
    let onSelect: (String) -> Void

    @State private var selection: String?
    @Environment(\.colorScheme) var scheme

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
            VStack {
                HStack {
                    Text(selection ?? prompt)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                }
                .frame(height: 40)
                .background(scheme == .dark ? Color.black : Color.white)
                .padding(.horizontal)
                .onTapGesture {
                    withAnimation(.snappy) { isExpanded.toggle() }
                }
                
                if isExpanded {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack {
                                ForEach(options, id: \.self) { option in
                                    HStack {
                                        Text(option)
                                            .foregroundColor(selection == option ? .primary : .gray)
                                        
                                        Spacer()
                                        
                                        if option == selection {
                                            Image(systemName: "checkmark")
                                                .font(.subheadline)
                                        }
                                    }
                                    .frame(height: 40)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selection = option
                                        onSelect(option)
                                        withAnimation(.snappy) {
                                            isExpanded.toggle()
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: geometry.size.height)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .transition(.move(edge: .bottom))
                }
                    
            }
            .background(scheme == .dark ? Color.black : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .primary.opacity(0.5), radius: 4)
        }
        .padding(.horizontal)
    }
}
