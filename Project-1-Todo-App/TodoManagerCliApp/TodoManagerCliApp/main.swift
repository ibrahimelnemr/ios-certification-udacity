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
                
                print("Successfully saved todos to file: \(self.filename)")
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
            print("file url: \(fileURL)")
            let data = try Data(contentsOf: fileURL)
            fileData = data
        }
        
        catch {
            print("error fetching data from file: \(error.localizedDescription)")
            return nil
        }
        
        do {
//            if let jsonArray = try JSONSerialization.jsonObject(with: fileData, options: []) as? [[String: Any]] {
//                
//                print("json array: \(jsonArray)")
//                
//                jsonDataArray = jsonArray
//            }
            
            if let decodedJSONData = decodeTodos(data: fileData) {
                print("JSON cache loaded succesfully.")
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
}

//// TodoManager class

final class TodoManager {
    
    private var cache: Cache
    
    init(cache: Cache) {
        self.cache = cache
    }
    
    func listTodos() {
        guard let todos = self.cache.load() else {
            print("could not list todos; error loading todos from cache.")
            return
        }
        
        for todo in todos {
            print(todo)
        }
    }
    
    func addTodo(with title: String) {
        var newTodo: Todo = Todo(id: UUID(), title: title, isCompleted: false)
        
        print(type(of: newTodo))
        
        guard var todos = self.cache.load() else {
            print("could not list todos; error loading todos from cache.")
            return
        }
        
        var newTodos = [newTodo]
        
        print("newtodos: \(newTodos)")
        
        var updatedTodos: [Todo] = todos + [newTodo]
        
        print("updated todos: \(updatedTodos)")
        self.cache.save(todos: updatedTodos)
    }
    
    func toggleCompletion(forTodoAtIndex index: Int) {
        
    }
    
    func deleteTodo(atIndex index: Int) {
        
    }
}

//// App class

final class App {
    
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
    
    func run() {
        
        let message = """
Enter a command. Your command must be one of the following:
- add
- list
- toggle
- delete
- exit
"""
        var commandEntered: String = promptForCommand(message: message)
        
        while !validateCommand(commandEntered) {
            commandEntered = promptForCommand(message: message)
        }
        
    }
}

//// Setup and run

let demoTodos = [
    Todo(id: UUID(), title: "First Todo", isCompleted: false),
    Todo(id: UUID(), title: "Second Todo", isCompleted: false)
]

let demoTodos2 = [
    Todo(id: UUID(), title: "Third Todo", isCompleted: false)
]



let app = App()
app.run()
var jsonCache = JSONFileManagerCache(filename: "data.json")
var memoryCache = InMemoryCache()

let todoManager = TodoManager(cache: jsonCache)

print("writing new todo")
todoManager.addTodo(with: "demo task")
