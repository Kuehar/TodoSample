//
//  ContentView.swift
//  TodoSample
//
//  Created by kuehar on 2021/06/08.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Property
    
    @State var task: String = ""
    
    private var isButtonDisabled:Bool{
        task.isEmpty
    }
    
    // Fetch data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    // Function
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            task = ""
            hideKeyboard()
        }
    }
    
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing:16){
                    TextField("New Task",text: $task)
                        .padding()
                        .background(
                            Color(UIColor.systemGray6)
                        )
                        .cornerRadius(10)
                    
                    Button(action: {
                        addItem()
                    },label:{
                        Spacer()
                        Text("SAVE")
                        Spacer()
                    })
                    .disabled(isButtonDisabled)
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(isButtonDisabled ? Color.gray : Color.pink)
                    .cornerRadius(10)
                }// Vstack
                .padding()
                
                List {
                    ForEach(items) { item in
                        VStack(alignment: .leading){
                            Text(item.task ?? "")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }// ListItem
                    }
                    .onDelete(perform: deleteItems)
                }//: LIST
                }// Vstack
            .navigationBarTitle("Daily Tasks",displayMode:.large)
            .toolbar {
                    #if os(iOS)
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    #endif
            }//: ToolBar
            }// VStack
        }//: Navigation
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
