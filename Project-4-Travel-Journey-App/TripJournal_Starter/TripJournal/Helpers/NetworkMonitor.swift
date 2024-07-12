//
//  NetworkMonitor.swift
//  TripJournal
//

import Combine
import Network

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected: Bool = true
    @Published var usingCellular: Bool = false

    private var previousIsConnected: Bool = true

    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let newIsConnected = path.status == .satisfied
                if newIsConnected != self.previousIsConnected {
                    self.isConnected = newIsConnected
                    self.previousIsConnected = newIsConnected
                }
                self.usingCellular = path.isExpensive
            }
        }
        monitor.start(queue: queue)
    }
}
