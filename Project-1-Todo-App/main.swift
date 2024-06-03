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

public enum Command {
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
    func run() {
        print("Enter a command: ")

        let command = readLine()

        guard let commandEntered = command else {
            return
        }

        print("You entered command: \(commandEntered)")
    }
}

//// Setup and run

let app = App()
app.run()