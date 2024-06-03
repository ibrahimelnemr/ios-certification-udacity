// * The `App` class should have a `func run()` method, this method should perpetually 
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases 
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
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
