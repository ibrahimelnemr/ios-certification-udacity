import Foundation

//// Todo struct
public struct Todo: CustomStringConvertible, Codable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    public var description: String {
        get {
            return "todo"
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
        
    }
    
    func load() -> [Todo]? {
        
        var fileData: Data
//        var jsonData: [String: Any]
//        var jsonData: Any
        var jsonData: [Any]
        
        do  {
            print("File url: \(fileURL)")
            let data = try Data(contentsOf: fileURL)
            print(data.base64EncodedString())
            fileData = data
        } catch {
            print("Error fetching data from file: \(error.localizedDescription)")
            return []
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: fileData, options: [])
            print(json)
            jsonData = json as! [Any]
            print(jsonData)
            for item in jsonData {
                print(item)
            }
        } catch {
            print("Error serializing data as json: \(error.localizedDescription)")
        }
    
        return []
    }
    
}

//// InMemoryCache class

final class InMemoryCache: Cache {
    func save(todos: [Todo]) {
        
    }
    
    func load() -> [Todo]? {
        return []
    }
}

//// TodoManager class

final class TodoManager {
    func listTodos() {
        
    }
    
    func addTodo(with title: String) {
        
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


let app = App()
app.run()
var jsonCache = JSONFileManagerCache(filename: "data.json")
jsonCache.load()
