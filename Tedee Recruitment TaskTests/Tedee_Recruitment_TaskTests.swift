import XCTest
@testable import Tedee_Recruitment_Task

class Tedee_Recruitment_Task_PinsManagerTests: XCTestCase {
    var pinsManager: PinsManager!
    
    override func setUpWithError() throws {
        pinsManager = .mock
    }
    
    override func tearDown() {
        pinsManager = .mock
    }
    
    func testGetPinsCount_Standard_Returns3() throws {
        XCTAssertEqual(pinsManager.count, 3)
    }
    
    func testGetPinName_First_ReturnsAlbania() throws {
        XCTAssertEqual(pinsManager.getName(ofPinAt: 0), "Albania")
    }
    
    func testRepleacePin_First_ReturnsBelgia() throws {
        let newPin = Pin(name: "Hiszpania", code: "123765")
        let oldPin = pinsManager.pins[0]
        pinsManager.repleacePin(oldPin, for: newPin)
        XCTAssertEqual(pinsManager.getName(ofPinAt: 0), "Belgia")
    }
    
    func testAddPin_Add4thPin_ReturnsCount4() throws {
        let newPin = Pin(name: "Rower", code: "125665")
        pinsManager.addPin(newPin)
        XCTAssertEqual(pinsManager.count, 4)
    }
    
    func testRemovePin_First_ReturnsCount3() throws {
        pinsManager.removePin(at: 0)
        XCTAssertEqual(pinsManager.count, 2)
    }
}

class Tedee_Recruitment_Task_DetailsLogicTests: XCTestCase {
    var detailsLogic: DetailsLogicMock!
    
    override func setUpWithError() throws {
        detailsLogic = DetailsLogicMock()
    }

    func testConsecutivness_134568_ReturnsFalse() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([1,3,4,5,6,8]), false)
    }
    
    func testConsecutivness_123456_ReturnsTrue() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([1,2,3,4,5,6]), true)
    }
    
    func testConsecutivness_654321_ReturnsFalse() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([6,5,4,3,2,1]), true)
    }
    
    func testConsecutivness_654322_ReturnsFalse() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([6,5,4,3,2,2]), false)
    }
    
    func testConsecutivness_456789_ReturnsTrue() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([4,5,6,7,8,9]), true)
    }
    
    func testConsecutivness_987654_ReturnsFalse() throws {
        XCTAssertEqual(detailsLogic.testArrayForConsecutivness([9,8,7,6,5,4]), true)
    }
}
