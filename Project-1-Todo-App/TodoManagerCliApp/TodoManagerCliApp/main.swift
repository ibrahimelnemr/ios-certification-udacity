import Foundation

//// Todo struct
public struct Todo: CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    public var description: String {
        get {
            return
            """
            \n\tTodo 🎯
            \tID: \(id)
            \tTitle: \(title)
            \tisCompleted: \(isCompleted)\(isCompleted ? "✅" : "❌")\n
            """
        }
    }
}

//// Cache protocol

public protocol Cache {
    func save(todos: [Todo])
    func load() -> [Todo]?
    func clear()
}

//// Command enum

enum Command: String, CaseIterable {
    case add
    case list
    case toggle
    case delete
    case exit
}

//// FileSystemCache class

final class JSONFileManagerCache: Cache {
    private var filename: String
    private var fileURL: URL
    private var todos: [Todo]
    
    init(filename: String) {
        self.filename = filename
        self.fileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent(filename)
        self.todos = []
    }
    
    func save(todos: [Todo]) {
        
        do {
            
            if let jsonData = encodeTodos(todos: todos) {
                
                try jsonData.write(to: self.fileURL)
            }
        }
        
        catch {
            print("\t‼️ Error saving todos: \(error.localizedDescription)")
        }
    }
    
    func encodeTodos(todos: [Todo]) -> Data? {
        do {
            let encoder = JSONEncoder()
            
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(todos)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                //                print(jsonString)
            }
            return jsonData
        }
        catch {
            print("\t‼️ Error encoding: \(error.localizedDescription)")
            return nil
        }
    }
    
    func decodeTodos(data: Data) -> [Todo]? {
        do {
            let decoder = JSONDecoder()
            let todos = try decoder.decode([Todo].self, from: data)
            return todos
        }
        
        catch {
            print("\t‼️ Error decoding todos: \(error.localizedDescription)")
            return nil
        }
    }
    
    func writeDemoTodos(demoTodos: [Todo]) {
        do {
            
            if let jsonData = encodeTodos(todos: demoTodos) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    //                    print(jsonString)
                }
                try jsonData.write(to: self.fileURL)
            }
        }
        catch {
            print("\t‼️ Error: \(error.localizedDescription)")
        }
    }
    
    func load() -> [Todo]? {
        
        var fileData: Data
        var jsonDataArray: [[String: Any]]
        
        do {
            //            print("file url: \(fileURL)")
            let data = try Data(contentsOf: fileURL)
            fileData = data
        }
        
        catch {
            print("\t‼️ Error fetching data from file: \(error.localizedDescription)")
            return nil
        }
        
        do {
            
            if let decodedJSONData = decodeTodos(data: fileData) {
                return decodedJSONData
            }
            else {
                print("\t‼️ Error loading json data")
                return nil
            }
        }
        
        catch {
            print("error serializing data as json: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clear() {
        do {
            
            if let jsonData = encodeTodos(todos: []) {
                try jsonData.write(to: self.fileURL)
//                print("successfully cleared todos from file cache.")
            }
        }
        
        catch {
            print("\t‼️ Error saving todos: \(error.localizedDescription)")
        }
    }
    
}

//// InMemoryCache class

final class InMemoryCache: Cache {
    private var todos: [Todo]
    
    init() {
        self.todos = []
    }
    func save(todos: [Todo]) {
        self.todos = todos
    }
    
    func load() -> [Todo]? {
        return self.todos
    }
    
    func clear() {
        self.todos = []
    }
}

//// TodoManager class

final class TodoManager {
    
    private var cache: Cache
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    func listTodos() {
        
        guard let todos = self.cache.load() else {
            print("\t‼️ Error loading todos from cache.")
            return
        }
        
        if todos.isEmpty {
            print("\t❗️ There are currently no todos.")
        }
        
        for todo in todos {
            print(todo)
        }
    }
    
    func getTodos() -> [Todo]? {
        
        guard let todos = self.cache.load() else {
            print("\t‼️ Error loading todos from cache.")
            return nil
        }
        
        return todos
    }
    
    func addTodo(with title: String) {
        
        var newTodo: Todo = Todo(id: UUID(), title: title, isCompleted: false)
        
        guard var todos = self.cache.load() else {
            print("\t‼️ Error loading todos from cache.")
            return
        }
        
        self.cache.save(todos: todos + [newTodo])
        
        print("✅ Successfully added todo")
        print(newTodo)
        
    }
    
    func toggleCompletion(forTodoAtIndex index: Int) {
        
        guard var todos = self.cache.load() else {
            print("\t‼️ Error loading todos from cache.")
            return
        }
        
        if index >= todos.count {
            print("\t‼️ Error toggling completion: index not valid.")
            return
        }
        
        todos[index].isCompleted = !todos[index].isCompleted
        
        print("✅ Successfully toggled completion.")
        print("Updated todo:")
        print(todos[index])
        
        self.cache.save(todos: todos)
        
    }
    
    func deleteTodo(atIndex index: Int) {
        guard var todos = self.cache.load() else {
            print("\t‼️ Error loading todos from cache.")
            return
        }
        
        if index >= todos.count {
            print("\t‼️ Error removing todo: index not valid.")
            return
        }
        print()
        print("\t🔄 Removing todo at index \(index). Current number of todos: \(todos.count)")
        print()
        print("\t🗑️ Todo removed: ")
        print(todos[index])
        
        todos.remove(at: index)
        
        print("\t✅ Successfully removed todo at index \(index). Current number of todos: \(todos.count)")
        print()
        
        self.cache.save(todos: todos)
    }
}

//// App class

final class App {
    
    init(todoManager: TodoManager) {
        self.todoManager = todoManager
    }
    
    private var todoManager: TodoManager
    
    func validateCommand(_ command: String) -> Bool {
//        print("You entered command: \(command)")
        
        for item in Command.allCases {
            if command == item.rawValue {
//                print("Your input is within the commands")
                return true
            }
        }
        print("Your command \(command) does not match any of the commands listed. Enter a command again.")
        return false
    }
    
    func promptForCommand(message: String) -> String {
        print(message)
        print("Enter a command: ")
        let command = readLine()
        return command!
    }
    
    func executeCommandFunction(command: String) {
        
        switch command {
        case Command.add.rawValue:
            print("\t 📋 Adding a todo")
            print("\t Enter the name of a Todo to add: ")
            
            guard var name = readLine() else { return }
            
            todoManager.addTodo(with: name)
        
        case Command.list.rawValue:
            print("\t📝 Listing todos")
            todoManager.listTodos()
            
        case Command.delete.rawValue:
            print("\t🗑️ Deleting a todo")
            print("\tEnter the index of a todo to delete: ")
            
            guard let todos = todoManager.getTodos() else {
                print("\t‼️ Error retrieving todos to show available indexes")
                return
            }
            
            print("\t Available indexes: ")
            for (idx, todo) in todos.enumerated() {
                print("\t\t \(idx) \(todo.title)")
            }
            
            guard let rawIndex = readLine(), let index = Int(rawIndex) else {
                print("‼️ Invalid index entered. try again.")
                return
            }
            
            todoManager.deleteTodo(atIndex: index)
            
        case Command.toggle.rawValue:
            print("\t✅ Toggling completion")
            print("\tEnter the index of a todo to toggle completion of: ")
            
            
            guard let todos = todoManager.getTodos() else {
                print("\tError retrieving todos to show available indexes")
                return
            }
            
            print("\tAvailable indexes: ")
            for (idx, todo) in todos.enumerated() {
                print("\t\t \(idx) \(todo.title)")
            }
            
            guard let rawIndex = readLine(), let index = Int(rawIndex) else {
                print("\t‼️ Invalid index entered. try again.")
                return
            }
            
            todoManager.toggleCompletion(forTodoAtIndex: index)
            
        case Command.exit.rawValue:
            print("\t⬅️ Exiting")
            
        default:
            print("\t‼️ The command you entered was not a valid one, try again.")
            
        }
    }
    
    func run() {
        
        let message = """
Enter a command. Your command must be one of the following:
🔖\tadd
📝\tlist
📌\ttoggle
🗑️\tdelete
⬅️\texit
"""
        var commandEntered: String = ""
        
        var running = true
        
        while (running) {
            
            executeCommandFunction(command: commandEntered)
            
            commandEntered = promptForCommand(message: message)
            
            if !validateCommand(commandEntered) {
                commandEntered = promptForCommand(message: message)
            }
            
            if (commandEntered) == Command.exit.rawValue {
                executeCommandFunction(command: commandEntered)
                running = false
            }
            
        }
        
        
        
    }
}


var jsonCache = JSONFileManagerCache(filename: "data.json")
jsonCache.clear()

let todoManager = TodoManager(cache: jsonCache)

let app = App(todoManager: todoManager)
app.run()
