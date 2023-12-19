//
//  ContentView.swift
//  ToDo
//
//  Created by Ashrith Mandayam Athmaram on 12/19/23.
//

import SwiftUI
import CoreData

struct Todo: Identifiable, Hashable {
    let id: Int
    let title: String
    let date: Date
    let status: String
    let category: String
}

// Helper function to create Date instances from components
func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = TimeZone.current
    let calendar = Calendar.current
    return calendar.date(from: components)!
}


struct TodoDetailView: View {
    var todo: Todo

//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text(todo.title)
//                .font(.title)
//            Text(formatDate(todo.date))
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            Text(todo.status)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .navigationTitle("Todo Details")
//    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    let todos: [Todo] = [
        Todo(id: 1, title: "Buy groceries", date: createDate(year: 2023, month: 7, day: 20, hour: 9, minute: 0), status: "incomplete", category: "Home"),
        Todo(id: 2, title: "Finish homework", date: createDate(year: 2023, month: 7, day: 21, hour: 15, minute: 30), status: "incomplete", category: "School"),
        Todo(id: 3, title: "Call mom", date: createDate(year: 2023, month: 7, day: 22, hour: 12, minute: 0), status: "incomplete", category: "Personal"),
        ]
    
    var body: some View {
            NavigationView {
                List {
                    ForEach(todos, id: \.self) { todo in
                        NavigationLink(destination: TodoDetailView(todo: todo)) {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text(todo.title)
                                        .font(.title3)
                                    Text(formatDate(todo.date))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .padding()
                .navigationTitle("Todo List")
            }
        }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

//    var body: some View {
//        NavigationView {
//            List {
//                Text("Categories")
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
    

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
