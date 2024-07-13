import Combine
import Foundation

enum HTTPMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
    case form = "application/x-www-form-urlencoded"
}

enum HTTPHeaders: String {
    case accept
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum NetworkError: Error {
    case badUrl
    case badResponse
    case failedToDecodeResponse
    case invalidValue
}

enum SessionError: Error {
    case expired
}

extension SessionError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .expired:
            return "Your session has expired. Please log in again."
        }
    }
}


/// An unimplemented version of the `JournalService`.
class UnimplementedJournalService: JournalService {
    
    var tokenExpired: Bool = false

        @Published private var token: Token? {
            didSet {
                if let token = token {
                    try? KeychainHelper.shared.saveToken(token)
                } else {
                    try? KeychainHelper.shared.deleteToken()
                }
            }
        }

    var isAuthenticated: AnyPublisher<Bool, Never> {
        $token
            .map { $0 != nil }
            .eraseToAnyPublisher()
    }

    // MARK: - Endpoints

    enum EndPoints {
        static let base = "http://localhost:8000/"

        case register
        case login
        
        case trips
        case handleTrip(String)
        
        case events
        case handleEvent(String)
        
        case media
        case handleMedia(String)

        private var stringValue: String {
            switch self {

            case .register:
                return EndPoints.base + "register"
            case .login:
                return EndPoints.base + "token"
            
            case .trips:
                return EndPoints.base + "trips"
            case .handleTrip(let tripId):
                return EndPoints.base + "trips/\(tripId)"
                
            case .events:
                return EndPoints.base + "events"
            case .handleEvent(let eventId):
                return EndPoints.base + "events/\(eventId)"
                
            case .media:
                return EndPoints.base + "media"
            case .handleMedia(let mediaId):
                return EndPoints.base + "media/\(mediaId)"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    // Shared URLSession instance
    private let urlSession: URLSession

    private let tripCacheManager = TripCacheManager()
    @Published private var networkMonitor = NetworkMonitor()

    // MARK: - Initialization

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        self.urlSession = URLSession(configuration: configuration)

        if let savedToken = try? KeychainHelper.shared.getToken() {
            if !isTokenExpired(savedToken) {
                self.token = savedToken
            } else {
                self.tokenExpired = true
                self.token = nil
            }
        } else {
            self.token = nil
        }
    }
    
    // MARK: - Authentication Methods

    func register(username: String, password: String) async throws -> Token {
        let request = try createRegisterRequest(username: username, password: password)
        var token = try await performNetworkRequest(request, responseType: Token.self)
        token.expirationDate = Token.defaultExpirationDate()
        self.token = token
        return token
    }

    func logOut() {
        token = nil
    }

    func logIn(username: String, password: String) async throws -> Token {
        let request = try createLoginRequest(username: username, password: password)
        var token = try await performNetworkRequest(request, responseType: Token.self)
        token.expirationDate = Token.defaultExpirationDate()
        self.token = token
        return token
    }
    
    func checkIfTokenExpired() {
        if let currentToken = token,
           isTokenExpired(currentToken) {
            tokenExpired = true
            token = nil
        }
    }
    
    private func isTokenExpired(_ token: Token) -> Bool {
        guard let expirationDate = token.expirationDate else {
            return false
        }
        return expirationDate <= Date()
    }
    
    private func createURLRequest(url: URL, httpMethod: HTTPMethods)  throws -> URLRequest {
        
        guard let token = token else {
            print("createURLRequest(): error - cannot find token")
            throw NetworkError.invalidValue
        }
        
//        guard let url1 = URL(string: url) else {
//            print("createURLRequest: unable to create URL from string provided")
//            throw URLError(.badURL)
//        }
                
//        var requestURL = URLRequest(url: url1)
        
        var requestURL = URLRequest(url: url)
        
        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        
        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
     
        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        requestURL.httpMethod = httpMethod.rawValue
        
        return requestURL
    }

    func createTrip(with request: TripCreate) async throws -> Trip {
        guard let token = token else {
            throw NetworkError.invalidValue
        }
        
        var requestURL = try createURLRequest(url: EndPoints.trips.url, httpMethod: HTTPMethods.POST)

//        var requestURL = URLRequest(url: EndPoints.trips.url)
        
//        requestURL.httpMethod = HTTPMethods.POST.rawValue
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        print("Access token: ")
        print(token.accessToken)
        

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        let tripData: [String: Any] = [
            "name": request.name,
            "start_date": dateFormatter.string(from: request.startDate),
            "end_date": dateFormatter.string(from: request.endDate)
        ]
        
        requestURL.httpBody = try JSONSerialization.data(withJSONObject: tripData)

        return try await performNetworkRequest(requestURL, responseType: Trip.self)
    }

    func getTrips() async throws -> [Trip] {
        
        guard let token = token else {
            throw NetworkError.invalidValue
        }

        // Check network connection
        if !networkMonitor.isConnected {
            print("Offline: Loading trips from UserDefaults")
            return tripCacheManager.loadTrips()
        }
        
        var requestURL = try createURLRequest(url: EndPoints.trips.url, httpMethod: HTTPMethods.GET)


//        var requestURL = URLRequest(url: EndPoints.trips.url)
        
//        requestURL.httpMethod = HTTPMethods.GET.rawValue
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        print("Access token: ")
        print(token.accessToken)

        do {
            
            print("Journalservice getTrips: attempting to get trips")

            
            let trips = try await performNetworkRequest(requestURL, responseType: [Trip].self)
//            print("Trips: ")
//            print(trips)
            
            print("saving trips to cache")
            tripCacheManager.saveTrips(trips)
            print("trips saved to cache successfully")
            
            return trips
            print("journalservice: getTrips - returned trips")
        } catch {
            print("Fetching trips failed, loading from UserDefaults")
            return tripCacheManager.loadTrips()
        }
    }
    
    

    func getTrip(withId tripId: Trip.ID) async throws -> Trip {
        guard let token = token else {
            throw NetworkError.invalidValue
        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleTrip(tripId.description).url, httpMethod: HTTPMethods.GET)
        
//        let url = EndPoints.handleTrip(tripId.description).url
//        var requestURL = URLRequest(url: url)
//        requestURL.httpMethod = HTTPMethods.GET.rawValue
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        let trip = try await performNetworkRequest(requestURL, responseType: Trip.self)
        
        return trip
        
    }

    func updateTrip(withId tripId: Trip.ID, and trip: TripUpdate) async throws -> Trip {
        
        guard let token = token else {
            throw NetworkError.invalidValue
        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleTrip(tripId.description).url, httpMethod: HTTPMethods.PUT)
        
//        let url = EndPoints.handleTrip(tripId.description).url
        
//        var requestURL = URLRequest(url: url)
        
//        requestURL.httpMethod = HTTPMethods.PUT.rawValue
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        let tripData: [String: Any] = [
            "name": trip.name,
            "start_date": dateFormatter.string(from: trip.startDate),
            "end_date": dateFormatter.string(from: trip.endDate)
        ]
        
        requestURL.httpBody = try JSONSerialization.data(withJSONObject: tripData)
        
        let updatedTrip = try await performNetworkRequest(requestURL, responseType: Trip.self)
        
        return updatedTrip
        
    }

    func deleteTrip(withId tripId: Trip.ID) async throws {
        
        print("journalservice - deleteTrip()")
        
        guard let token = token else {
            throw NetworkError.invalidValue
        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleTrip(tripId.description).url, httpMethod: HTTPMethods.DELETE)
        
//        let url = EndPoints.handleTrip(tripId.description).url
        
//        var requestURL = URLRequest(url: url)
        
//        requestURL.httpMethod = HTTPMethods.DELETE.rawValue
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        try await performVoidNetworkRequest(requestURL)
        
    }
    
    
    private func createRegisterRequest(username: String, password: String) throws -> URLRequest {
        var request = URLRequest(url: EndPoints.register.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

        let registerRequest = LoginRequest(username: username, password: password)
        request.httpBody = try JSONEncoder().encode(registerRequest)

        return request
    }
    
    private func createLoginRequest(username: String, password: String) throws -> URLRequest {
        var request = URLRequest(url: EndPoints.login.url)
        request.httpMethod = HTTPMethods.POST.rawValue
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        request.addValue(MIMEType.form.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

        let loginData = "grant_type=&username=\(username)&password=\(password)"
        request.httpBody = loginData.data(using: .utf8)

        return request
    }

    private func performNetworkRequest<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
//        print(data)
//        print(response)
//        print(httpResponse)

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
    
    private func performVoidNetworkRequest(_ request: URLRequest) async throws {
        let (_, response) = try await urlSession.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 204 else {
            throw NetworkError.badResponse
        }
    }
    

    func createEvent(with request: EventCreate) async throws -> Event {
//        fatalError("Unimplemented createEvent")
        
        guard let token = token else {
            throw NetworkError.invalidValue
        }
        
        var requestURL = try createURLRequest(url: EndPoints.events.url, httpMethod: HTTPMethods.POST)

//        var requestURL = URLRequest(url: EndPoints.events.url)
        
//        requestURL.httpMethod = HTTPMethods.POST.rawValue
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        let defaultLocation = Location(latitude: 0.0, longitude: 0.0, address: "")
        
        let location = request.location ?? defaultLocation
        
        let locationData: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "address": location.address ?? ""
        ]

        let eventData: [String: Any] = [
            "trip_id": request.tripId,
            "name": request.name,
            "date": dateFormatter.string(from: request.date),
            "location": locationData,
            "transition_from_previous": request.transitionFromPrevious ?? ""
        ]
        print(eventData)
        requestURL.httpBody = try JSONSerialization.data(withJSONObject: eventData)

        return try await performNetworkRequest(requestURL, responseType: Event.self)
        
    }

    func updateEvent(withId eventId: Event.ID, and event: EventUpdate) async throws -> Event {
        
//        guard let token = token else {
//            throw NetworkError.invalidValue
//        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleEvent(eventId.description).url, httpMethod: HTTPMethods.PUT)
        
//        let url = EndPoints.handleEvent(eventId.description).url
        
//        var requestURL = URLRequest(url: url)
        
//        requestURL.httpMethod = HTTPMethods.PUT.rawValue
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        
        let defaultLocation = Location(latitude: 0.0, longitude: 0.0, address: "")
        
        let location = event.location ?? defaultLocation
        
        let locationData: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "address": location.address ?? ""
        ]

        let eventData: [String: Any] = [
//            "trip_id": event.tripId,
            "name": event.name,
            "date": dateFormatter.string(from: event.date),
            "location": locationData,
            "transition_from_previous": event.transitionFromPrevious ?? ""
        ]
        print(eventData)
        
        print("updateEvent - Checking if eventdata can be serialized as json")
        guard JSONSerialization.isValidJSONObject(eventData) else {
            print("createMedia - cannot serialize object: ")
            print(eventData)
            throw NetworkError.invalidValue
        }
        print("event can be serialized as json")
        
        let jsonData = try JSONSerialization.data(withJSONObject: eventData, options: .prettyPrinted)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Serialized JSON object: \(jsonString)")
        }
        
        requestURL.httpBody = jsonData
        
        let updatedEvent = try await performNetworkRequest(requestURL, responseType: Event.self)
        
        return updatedEvent
        
    }

    func deleteEvent(withId eventId: Event.ID) async throws {
        print("journalservice - deleteEvent()")
        
//        guard let token = token else {
//            throw NetworkError.invalidValue
//        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleEvent(eventId.description).url, httpMethod: HTTPMethods.DELETE)

        
//        let url = EndPoints.handleEvent(eventId.description).url
        
//        var requestURL = URLRequest(url: url)
        
//        requestURL.httpMethod = HTTPMethods.DELETE.rawValue
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)

        try await performVoidNetworkRequest(requestURL)
    }

    func createMedia(with request: MediaCreate) async throws -> Media {
        
//        guard let token = token else {
//            throw NetworkError.invalidValue
//        }
        
        var requestURL = try createURLRequest(url: EndPoints.media.url, httpMethod: HTTPMethods.POST)
        
//        print(EndPoints.media.url)

//        var requestURL = URLRequest(url: EndPoints.media.url)
        
//        requestURL.httpMethod = HTTPMethods.POST.rawValue
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)
        
//        requestURL.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        let base64String = request.base64Data.base64EncodedString()

        let mediaData: [String: Any] = [
//            "caption": request.caption,
            "base64_data": base64String,
            "event_id": request.eventId
        ]
        
        guard JSONSerialization.isValidJSONObject(mediaData) else {
            print("createMedia - cannot serialize object: ")
            print(mediaData)
            throw NetworkError.invalidValue
        }

        
        requestURL.httpBody = try JSONSerialization.data(withJSONObject: mediaData)

        return try await performNetworkRequest(requestURL, responseType: Media.self)
    }

    func deleteMedia(withId mediaId: Media.ID) async throws {
        
        print("journalservice - deleteMedia()")
        
        
//        guard let token = token else {
//            throw NetworkError.invalidValue
//        }
        
        var requestURL = try createURLRequest(url: EndPoints.handleMedia(mediaId.description).url, httpMethod: HTTPMethods.DELETE)
        
//        let url = EndPoints.handleMedia(mediaId.description).url
        
//        var requestURL = URLRequest(url: url)
        
//        print(requestURL)
        
//        requestURL.httpMethod = HTTPMethods.DELETE.rawValue
        
//        requestURL.addValue("Bearer \(token.accessToken)", forHTTPHeaderField: HTTPHeaders.authorization.rawValue)

        try await performVoidNetworkRequest(requestURL)
    }
}
