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
    func save(todos: [Todo]) {
        
    }
    
    func load() -> [Todo]? {
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
        var command = readLine()
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
//        print(message)
//        print("Enter a command: ")
//        
//        var itemFound = false
//        let command = readLine()
//        guard let commandEntered = command else {
//            return
//        }
        
        let commandEntered: String
        
        while !validateCommand(commandEntered) {
            commandEntered = promptForCommand(message: message)
        }
        

        while !itemFound {
            let command = readLine()
            
            
            
            print("You entered command: \(commandEntered)")
            
            
            
            for item in Command.allCases {
                if commandEntered == item.rawValue {
                    print("Your input is within the commands")
                    itemFound = true
                    break
                }
            }
            if !itemFound {
                print("Enter a command again, your command was not among those included.")
            }
        }
        
    }
}

//// Setup and run

let fileManager = FileManager.default

let app = App()
app.run()
