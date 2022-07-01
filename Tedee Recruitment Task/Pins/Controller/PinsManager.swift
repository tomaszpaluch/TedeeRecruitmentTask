import Foundation

class PinsManager {
    private let pinsPersistance: PinsPersistance
    private(set) var pins: [Pin]
    
    var count: Int {
        pins.count
    }
    
    init(pinsPersistance: PinsPersistance) {
        self.pinsPersistance = pinsPersistance
        pins = pinsPersistance.load()
    }
    
    func repleacePin(_ oldPin: Pin, for newPin: Pin) {
        if let index = pins.firstIndex(where: { $0 == oldPin }) {
            pins.remove(at: index)
        }
        
        addPin(newPin)
    }
    
    func addPin(_ pin: Pin) {
        pins.append(pin)
        pins.sort {$0.name < $1.name}
        
        pinsPersistance.save(pins: pins)
    }
    
    func getName(ofPinAt index: Int) -> String {
        pins[index].name
    }
    
    func removePin(at index: Int) {
        pins.remove(at: index)
        
        pinsPersistance.save(pins: pins)
    }
}

extension PinsManager {
    static var mock: PinsManager {
        .init(pinsPersistance: .mock)
    }
}
