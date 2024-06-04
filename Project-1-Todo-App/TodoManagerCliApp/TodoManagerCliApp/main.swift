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
            \n\t<Todo> 🎯
            \tID: \(id)
            \tTitle: \(title)
            \tisCompleted: \(isCompleted)\n
            """
        }
    }
}

//// Cache protocol

public protocol Cache {
    func save(todos: [Todo]) //Persists the given todos.
    func load() -> [Todo]? //Retrieves and returns the saved todos, or nil if none exist.
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
                
                //                print("Successfully saved todos to file: \(self.filename)")
            }
        }
        
        catch {
            print("error saving todos: \(error.localizedDescription)")
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
            print("error encoding: \(error.localizedDescription)")
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
            print("error decoding todos: \(error.localizedDescription)")
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
            print("error: \(error.localizedDescription)")
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
            print("error fetching data from file: \(error.localizedDescription)")
            return nil
        }
        
        do {
            
            if let decodedJSONData = decodeTodos(data: fileData) {
                return decodedJSONData
            }
            else {
                print("error loading json data")
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
                print("successfully cleared todos from file cache.")
            }
        }
        
        catch {
            print("error saving todos: \(error.localizedDescription)")
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
            print("error loading todos from cache.")
            return
        }
        
        print(todos)
    }
    
    func getTodos() -> [Todo]? {
        
        guard let todos = self.cache.load() else {
            print("error loading todos from cache.")
            return nil
        }
        
        return todos
    }
    
    func addTodo(with title: String) {
        
        var newTodo: Todo = Todo(id: UUID(), title: title, isCompleted: false)
        
        guard var todos = self.cache.load() else {
            print("error loading todos from cache.")
            return
        }
        
        self.cache.save(todos: todos + [newTodo])
        
    }
    
    func toggleCompletion(forTodoAtIndex index: Int) {
        
        guard var todos = self.cache.load() else {
            print("error loading todos from cache.")
            return
        }
        
        if index >= todos.count {
            print("error toggling completion: index not valid.")
            return
        }
        
        todos[index].isCompleted = !todos[index].isCompleted
        
        self.cache.save(todos: todos)
        
    }
    
    func deleteTodo(atIndex index: Int) {
        guard var todos = self.cache.load() else {
            print("error loading todos from cache.")
            return
        }
        
        if index >= todos.count {
            print("error removing todo: index not valid.")
            return
        }
        
        todos.remove(at: index)
        
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
        print("You entered command: \(command)")
        
        for item in Command.allCases {
            if command == item.rawValue {
                print("Your input is within the commands")
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
            print("Enter the name of a Todo to add: ")
            
            guard var name = readLine() else { return }
            
//            guard let name = readLine() else {
//                print("could not get name entered. try again.")
//                return
//            }
            
            todoManager.addTodo(with: name)
        
        case Command.list.rawValue:
            print("Listing todos")
            todoManager.listTodos()
            
        case Command.delete.rawValue:
            print("Enter the index of a todo to delete: ")
            
            guard let todos = todoManager.getTodos() else {
                print("error retrieving todos to show available indexes")
                return
            }
            
            print("Available indexes: ")
            for (idx, todo) in todos.enumerated() {
                print("\t \(idx) \(todo.title)")
            }
            
            guard let rawIndex = readLine(), let index = Int(rawIndex) else {
                print("invalid index entered. try again.")
                return
            }
            
            todoManager.deleteTodo(atIndex: index)
            
        case Command.toggle.rawValue:
            print("Enter the index of a todo to toggle completion of: ")
            
            
            guard let todos = todoManager.getTodos() else {
                print("error retrieving todos to show available indexes")
                return
            }
            
            print("Available indexes: ")
            for (idx, todo) in todos.enumerated() {
                print("\t \(idx) \(todo.title)")
            }
            
            guard let rawIndex = readLine(), let index = Int(rawIndex) else {
                print("invalid index entered. try again.")
                return
            }
            
            todoManager.toggleCompletion(forTodoAtIndex: index)
            
        case Command.exit.rawValue:
            print("Exiting")
            
        default:
            print("The command you entered was not a valid one, try again.")
            
        }
    }
    
    func run() {
        
        let message = """
Enter a command. Your command must be one of the following:
🔖\tadd
📋\tlist
📌\ttoggle
❌\tdelete
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

//// Setup and run

//let demoTodos = [
//    Todo(id: UUID(), title: "First Todo", isCompleted: false),
//    Todo(id: UUID(), title: "Second Todo", isCompleted: false)
//]
//
//let demoTodos2 = [
//    Todo(id: UUID(), title: "Third Todo", isCompleted: false)
//]

//
//var memoryCache = InMemoryCache()
//memoryCache.clear()


var jsonCache = JSONFileManagerCache(filename: "data.json")
jsonCache.clear()

let todoManager = TodoManager(cache: jsonCache)

let app = App(todoManager: todoManager)
app.run()

//
//print("listing todos")
//todoManager.listTodos()
//
//print("writing new todo")
//todoManager.addTodo(with: "demo task")
//todoManager.listTodos()
//
//print("toggling completion at index 0")
//todoManager.toggleCompletion(forTodoAtIndex: 0)
//todoManager.listTodos()
//
//print("deleting todo at index 0")
//todoManager.deleteTodo(atIndex: 0)
//todoManager.listTodos()
