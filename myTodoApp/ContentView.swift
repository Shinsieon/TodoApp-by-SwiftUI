//
//  ContentView.swift
//  myTodoApp
//
//  Created by 신시언 on 2023/02/11.
//

import SwiftUI

struct ContentView: View {
    @State private var todoBtnOn:Bool = true
    @State private var toDos = UserDefaults.standard.array(forKey: "storedTodos") as? [String] ?? []
    @State private var doneTodos : [String] = []
    @State private var toDoText : String = ""
    @State private var presentAlert = false
    @GestureState private var isDetectingLongPress = false
    
    var body: some View {
        ZStack{
            Color(hex:"040403").ignoresSafeArea()
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
                                Button(action:{
                                    print(toDos.firstIndex(of: toDo)!)
                                }){
                                    Text(toDo)
                                        .foregroundColor(Color(hex:"040403"))
                                }
                                .font(.system(size: 20))
                                .frame(height: 90, alignment: .leading)
                                .scaleEffect(isDetectingLongPress ? 2: 1)
                                .animation(.spring(response:0.4, dampingFraction: 0.6))
                                .gesture(
                                    LongPressGesture(minimumDuration: 0.5)
                                        .updating($isDetectingLongPress){currentState, gestureState, transaction in
                                            gestureState = currentState
                                        }
                                        .onEnded{ value in
                                            print("fuck")
                                        }
                                )
                                
                                Spacer()
                                Button(action:{
                                    print("trash button")
                                    toDos.remove(at:toDos.firstIndex(of: toDo)!)
                                    UserDefaults.standard.set(toDos, forKey :"storedTodos")
                                }){
                                    Image(systemName: "trash")
                                        .font(.system(size : 20))
                                        .foregroundColor(Color(hex: "040403"))
                                        .shadow(color : .gray, radius: 0.2, x:1,y:1)

                                }
                                .animation(.easeInOut, value: 10)
                                
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color(hex : "F7E9B5"))
                                    .padding(.vertical,10)
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .padding(.horizontal, 20)
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
                    .foregroundColor(Color(hex:"F9D869"))
                    .shadow(color : .gray, radius: 0.2, x:1,y:1)
                    .padding()
            }
            .alert("할일을 적어주세요", isPresented: $presentAlert, actions:{
                TextField("", text: $toDoText)
                Button("Cancel", role: .cancel, action:{toDoText=""})
                Button("OK", action:{
                    if(!toDos.contains(toDoText)) {
                        addTodo(_t : toDoText)
                        toDoText=""
                    }else {toDoText = ""}
                })
            })
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
    func addTodo(_t : String){
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
            .foregroundColor(onTodo ? Color(hex:"040403") : Color(hex:"F9D869"))
            .background(onTodo ? Color(hex: "F9D869") : Color(hex:"040403"))
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
