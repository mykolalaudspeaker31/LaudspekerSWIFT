import XCTest
@testable import LaudspeakerSWIFT

final class LaudspeakerSWIFTTests: XCTestCase {
    let url = "http://localhost:3001"
    let apiKey = "qT64pt0iVbLMvQU47EN8oh5EgYYCJ1gWLnnH1CQy"
    let checkId = "659c0900530bce7b9a6781b0"
    let emailToCheck = "Myra_Daugherty80@yahoo.com"
    
    func testWebSocketConnection() {
        // Replace "Your API Key" with a valid API key
        let laudspeaker = LaudspeakerSWIFT(url: self.url, apiKey: self.apiKey)
        
        // Expectation for the asynchronous WebSocket connection
        let connectionExpectation = expectation(description: "WebSocket should connect")
        
        // Set up a timeout for how long we wait for the connection to succeed
        let timeout: TimeInterval = 10.0
        
        // Attempt to connect
        laudspeaker.connect()
        
        // If the WebSocket is connected, fulfill the expectation
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { // Delay to give time for connection attempt
            if laudspeaker.isConnected {
                connectionExpectation.fulfill()
            }
        }
        
        // Wait for the expectations to be fulfilled or timeout
        wait(for: [connectionExpectation], timeout: timeout)
        
        
        // After the expectation is fulfilled, check if the WebSocket is connected
        XCTAssertTrue(laudspeaker.isConnected, "WebSocket failed to connect")
        laudspeaker.disconnect()
        
    }
    
    func testWebSocketCustomerCreation() {
        let laudspeaker = LaudspeakerSWIFT(url: self.url, apiKey: self.apiKey)
        
        let indetifyExpectation = expectation(description: "WebSocket should connect and identify customer")
        let timeout: TimeInterval = 15.0
        
        laudspeaker.connect()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            laudspeaker.identify(uniqueProperties: ["email":self.emailToCheck])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            if laudspeaker.getCustomerId() == self.checkId {
                indetifyExpectation.fulfill()
            }
        }
        
        wait(for: [indetifyExpectation], timeout: timeout)
        
        
        XCTAssertTrue(laudspeaker.getCustomerId() == self.checkId, "WebSocket didn't identify customer to connect")
        laudspeaker.disconnect()
        
    }
}
