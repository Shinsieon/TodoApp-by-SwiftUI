//
//  ContentView.swift
//  myTodoApp
//
//  Created by 신시언 on 2023/02/11.
//

import SwiftUI

struct toDoStruct : Hashable{
    let name : String
    let key : String
    let checked : Bool
//    init(_name : String, _key : String, _checked : Bool){
//        name = _name
//        key = _key
//        checked = _checked
//    }
}
//= UserDefaults.standard.array(forKey: "storedTodos") as? [toDosStruct] ?? []
struct ContentView: View {
    @State private var todoBtnOn:Bool = true
    @State private var toDos  = [toDoStruct]()
    @State private var doneTodos : [String] = []
    @State private var toDoText : String = ""
    @State private var presentAlert = false
    @GestureState private var isDetectingLongPress = false
    @State private var checkBoxChecked = false
    
    var body: some View {
        ZStack{
            Color("todoBG").ignoresSafeArea()
            VStack{
                HStack(alignment: .top){
                    Button("Todo", action:{
                        self.todoBtnOn = true
                    }).buttonStyle(TopButtonStyle(onTodo : self.todoBtnOn))
                    
                    Button("Done", action:{
                        self.todoBtnOn = false
                    })
                    .buttonStyle(TopButtonStyle(onTodo : !self.todoBtnOn))
                    
                    Spacer()
                }
                .padding()
                if(!toDos.isEmpty){
                    List {
                        ForEach(todoBtnOn ? toDos : doneTodos, id : \.self) { toDo in
                            HStack{
                                Image(systemName: checkBoxChecked ? "app.badge.checkmark.fill" : "app.badge.checkmark")
                                    .font(.system(size : 30))
                                    .onTapGesture {
                                        checkBoxChecked.toggle()
                                    }
                                    .foregroundColor(Color.white)
                                Text(toDo.name)
                                    .padding()
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                                    .foregroundColor(Color("todoBG"))
                                    .background(Color("todoItem"))
                                    .cornerRadius(20)
                                    .overlay(
                                        HStack{
                                            Image(systemName: "square.and.pencil")
                                                 .font(.system(size : 25))
                                                 .foregroundColor(Color("todoBG"))
                                                 .shadow(color : .gray, radius: 0.2, x:1,y:1)
                                                 .onTapGesture {
                                                     print("modi")
                                                 }
                                            Image(systemName: "trash")
                                                 .font(.system(size : 25))
                                                 .foregroundColor(Color("todoBG"))
                                                 .shadow(color : .gray, radius: 0.2, x:1,y:1)
                                                 .onTapGesture {
                                                     toDos.remove(at:toDos.firstIndex(of: toDo)!)
                                                     UserDefaults.standard.set(toDos, forKey :"storedTodos")
                                                 }
                                        }
                                        .padding()
                                    ,alignment: .trailing)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color("todoBG"))
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(PlainListStyle())
                }else{
                    Text("Nothing to do")
                        .foregroundColor(Color.white)
                        .font(.system(size:30))
                        .frame(height : 500)
                        
                }
                Spacer()
            }
            .padding(.bottom)
            Button(action:{
                presentAlert.toggle()
            })
            {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size : 80))
                    .foregroundColor(Color(hex:"F0F8FF"))
                    .shadow(color : .gray, radius: 0.2, x:1,y:1)
                    .padding()
            }
            .alert("할일을 적어주세요", isPresented: $presentAlert, actions:{
                TextField("", text: $toDoText)
                Button("Cancel", role: .cancel, action:{toDoText=""})
                Button("OK", action:{
                    if(!toDos.contains(toDoText)) {
                        addTodo(_t : toDoStruct(name: toDoText, key: "232", checked: false))
                        toDoText=""
                    }else {toDoText = ""}
                })
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
    func addTodo(_t : toDoStruct){
        toDos.append(_t)
        UserDefaults.standard.set(toDos, forKey: "storedTodos")
    }
}

struct TopButtonStyle : ButtonStyle {
    let onTodo :Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 25))
            .foregroundColor(onTodo ? Color("todoBG") : Color("todoItem"))
            .background(onTodo ? Color("todoItem") : Color("todoBG"))
            .scaleEffect(configuration.isPressed ? 0.88 : 1.0)
            .clipShape(Capsule())

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
