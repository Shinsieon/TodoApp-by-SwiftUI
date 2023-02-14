//
//  ContentView.swift
//  myTodoApp
//
//  Created by 신시언 on 2023/02/11.
//

import SwiftUI

struct ContentView: View {
    @State private var todoBtnOn:Bool = true
    
    var body: some View {
        ZStack{
            Color(hex:"040403").ignoresSafeArea()
            VStack {
                HStack{
                    Button("Todo", action:{
                        self.todoBtnOn.toggle()
                    })
                    .buttonStyle(OnTopButtonStyle())
                    Button("Done", action:{
                        todoBtnOn = false
                    })
                    Spacer()
                }
                .padding()
            }
        }
        
    }
}

struct OnTopButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        //F9D869
            .padding()
            .clipShape(Capsule())
            .font(.system(size: 25))
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
    }
}
struct OffTopButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(.white))
            .clipShape(Capsule())
            .font(.system(size: 25))
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
    }
}
extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
