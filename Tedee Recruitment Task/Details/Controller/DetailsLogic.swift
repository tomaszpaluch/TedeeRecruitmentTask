import Foundation

class DetailsLogic {
    var coordinator: MainCoordinator?
    
    var setCode: ((String) -> Void)?
    var enableSaveButton: ((Bool) -> Void)? {
        didSet {
            enableSave()
        }
    }
    var savePinCompletion: ((Pin) -> Void)?
    var deletePinCompletion: (() -> Void)?

    private(set) var pin: Pin
    
    init(pin: Pin?) {
        self.pin = pin ?? Pin(name: "", code: "")
    }
    
    func setPinName(_ name: String) {
        pin = Pin(name: name, code: pin.code)
        
        enableSave()
    }
    
    func generateCode() {
        let possibleCharacters = 0...9
        var digitArray: [Int]
        
        repeat {
            digitArray = (0..<6).map { _ in possibleCharacters.randomElement() ?? 0 }
        } while isConsecutive(digitArray)
        
        let code = digitArray.reduce("", { result, element in
            return result + "\(element)"
        })
        
        pin = Pin(name: pin.name, code: code)
        setCode?(code)
        
        enableSave()
    }
    
    fileprivate func isConsecutive(_ input: [Int]) -> Bool {
        for index in (0 ..< input.count - 2) {
            if input[index] - input[index + 1] != input[index + 1] - input[index + 2] {
                return false
            }
        }
        
        return true
    }
    
    private func enableSave() {
        enableSaveButton?(!pin.name.isEmpty && pin.code.count == 6)
    }
    
    func deletePin() {
        deletePinCompletion?()
            
        coordinator?.popViewController()
    }
    
    func savePin() {
        savePinCompletion?(pin)
    }
}

class DetailsLogicMock: DetailsLogic {
    init() {
        super.init(pin: nil)
    }
    
    func testArrayForConsecutivness(_ input: [Int]) -> Bool {
        isConsecutive(input)
    }
}
