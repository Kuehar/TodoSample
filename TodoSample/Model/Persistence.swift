//
//  Persistence.swift
//  TodoSample
//
//  Created by kuehar on 2021/06/08.
//

import CoreData

struct PersistenceController {
    // 1.Persistent Controller
    
    static let shared = PersistenceController()

    // 2.persistent container

    let container: NSPersistentContainer
    
    // 3 initalization(load persistent data)

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TodoSample")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // 4.Preview
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
