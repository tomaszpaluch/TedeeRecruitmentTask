import Foundation

class PinsPersistance {
    private let fileURL: URL
    
    convenience init() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directoryURL = paths[0]
        let fileName = "saveFile"
        
        self.init(fileURL: directoryURL.appendingPathComponent(fileName))
    }
    
    fileprivate init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func load() -> [Pin] {
        var output: [Pin] = []
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
                        
            output = try decoder.decode([Pin].self, from: data)
        } catch {
            print(error)
        }
        
        return output
    }
    
    func save(pins: [Pin]) {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(pins)
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    static var mock: PinsPersistance {
        PinsPersistanceMock(fileURL: URL(
            fileURLWithPath: Bundle.main.path(
                forResource: "saveFile",
                ofType: "json"
            )!
        ))
    }
}

class PinsPersistanceMock: PinsPersistance {
    override func save(pins: [Pin]) {}
}
