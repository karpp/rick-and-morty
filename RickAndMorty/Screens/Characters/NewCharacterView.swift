//
//  NewCharacterView.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 24.05.2022.
//

import SwiftUI
import Kingfisher

//@Identifiable
struct MyData: Identifiable {
    let id = UUID()
    let title: String = "aaa"
    let subtitle: String = "aaa"
}

struct CharacterImageView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var imageUrl = URL(string: "https://rickandmortyapi.com/api/character/avatar/7.jpeg")

    var body: some View {
//        Image("")
        KFImage(imageUrl)
            .placeholder {
                Text("loading image")
            }
            .resizable()
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundColor(colorScheme == .dark ? Color.clear : Color(.main))
            }
            .padding(.horizontal, 22)
            
    }
}

struct CharacterInfoTitle: View {
    var title: String = "Pickle Rick"
    
    @State private var isLikeButtonPressed = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .default))
            Spacer()
            Image(systemName: "heart")
                .foregroundColor(isLikeButtonPressed ? Color(.main) : Color(.BG))
                .frame(width: 48, height: 48, alignment: .center)
                .padding(.trailing, 24)
                .background {
                    Circle()
                        .padding(.trailing, 24)
                        .foregroundColor(Color(.greyBG))
                }
                
        }
    }
}

struct NewCharacterView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State var data: [MyData] = [
        MyData(),
        MyData(),
        MyData(),
        MyData(),
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                CharacterImageView()
                CharacterInfoTitle()
                Text("Hello")
                ForEach(data) {
                    Text($0.title)
                }
                Button(action: {}, label: {Text("Button")})
                
            }
            .padding(16)
        }
    }
}

struct NewCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        NewCharacterView()
    }
}
