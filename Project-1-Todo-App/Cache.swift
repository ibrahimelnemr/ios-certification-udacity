public protocol Cache {
    func save(todos: [Todo]) //Persists the given todos.
    func load() -> [Todo]? //Retrieves and returns the saved todos, or nil if none exist.
}
