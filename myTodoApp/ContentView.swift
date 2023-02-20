//
//  ContentView.swift
//  myTodoApp
//
//  Created by 신시언 on 2023/02/11.
//

import SwiftUI

struct toDoStruct : Hashable, Codable{
    var name : String
    let key : Date
    var done : Bool
}
//=
struct ContentView: View {
    @State private var todoBtnOn:Bool = true
    @State private var toDos : [toDoStruct] = []
    @State private var UserDefaultsToDos = UserDefaults.standard.array(forKey: "storedTodos") as? [Data] ?? []
    @State private var toDoText : String = ""
    @State private var modiText : String = ""
    @State private var modiItem = toDoStruct(name: "temp", key: Date(), done: false)
    @State private var presentAlert = false
    @State private var presentModiAlert = false
    @GestureState private var isDetectingLongPress = false
    
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
                if(!toDos.filter{$0.done != todoBtnOn}.isEmpty){
                    List {
                        ForEach(toDos.filter{$0.done != todoBtnOn}, id : \.self) {toDo in
                            HStack{
                                Image(systemName: toDo.done ? "app.badge.checkmark.fill" : "app.badge.checkmark")
                                    .font(.system(size : 30))
                                    .onTapGesture {
                                        toDos[toDos.firstIndex(of: toDo)!].done.toggle()
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
                                                     modiItem = toDo
                                                     presentModiAlert.toggle()
                                                 }
                                            Image(systemName: "trash")
                                                 .font(.system(size : 25))
                                                 .foregroundColor(Color("todoBG"))
                                                 .shadow(color : .gray, radius: 0.2, x:1,y:1)
                                                 .onTapGesture {
                                                     deleteTodo(_t: toDo)
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
                    Text(todoBtnOn ? "Nothing to do" : "Nothing Done")
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
                    let item = toDoStruct(name: toDoText, key: Date(), done: false)
                    if(!toDoText.isEmpty) {
                        addTodo(_t : item)
                        toDoText=""
                    }else {toDoText = ""}
                })
            })
            .alert("할일 수정", isPresented: $presentModiAlert, actions:{
                TextField(modiItem.name, text: $modiText)
                Button("Cancel", role: .cancel, action:{modiText=""})
                Button("OK", action:{
                    if(!modiText.isEmpty) {
                        toDos[toDos.firstIndex(of: modiItem)!].name = modiText
                        modiText=""
                    }
                })
            })
            
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        .onAppear(perform: {
            let storedData = UserDefaults.standard.array(forKey: "storedTodos") as? [Data] ?? []
            if(!storedData.isEmpty){
                decodeStoredArray(data : storedData)
            }
            
        })
    }
    
    func addTodo(_t : toDoStruct){
        toDos.append(_t)
        encodeStoredArray(data: toDos)
    }
    func encodeObject(st : toDoStruct) -> Data{
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(st){
            return encoded
        }
        else { return Data() }
    }
    func decodeStoredArray(data : [Data]){
        let decoder = JSONDecoder()
        for item in data{
            if let savedObject = try? decoder.decode(toDoStruct.self, from: item) {
                toDos.append(savedObject)
            }
        }
    }
    func deleteTodo(_t : toDoStruct){
        toDos.remove(at:toDos.firstIndex(of: _t)!)
        encodeStoredArray(data: toDos)
    }
    func encodeStoredArray(data : [toDoStruct]){
        var tempUD : [Data] = []
        for item in data{
            let encoded = encodeObject(st: item)
            tempUD.append(encoded)
        }
        UserDefaults.standard.set(tempUD, forKey: "storedTodos")
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
