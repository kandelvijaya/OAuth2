//
//  Copyright © 2018 zalando.de. All rights reserved.
//

import XCTest
@testable import OAuthorize2
import Kekka

final class OAuth2Tests: XCTestCase {

    private let token = OAuth2AccessToken(accessToken: "token", tokenType: "kind", expiresIn: 100, refreshToken: "refreshToken")
    let service: OAuth2 = OAuthMock()
    lazy var network = (service.accessTokenNetworkService as? MockNetowrk)

    func test_whenAskForAccessTokenWithAuthCodeIsCalled_thenAPIIscalled() {
        let authCode = "123"
        network?.eventual(token: token)
        print(service.accessTokenNetworkService)
        service.askForAccessToken(with: authCode).then { tk in
            if case let .success(tk1) = tk {
                XCTAssertEqual(tk1.accessToken, self.token.accessToken)
            } else {
                XCTFail("Token doesnot match")
            }
        }.execute()
    }

    func test_whenAskforAccessTokenWithAuthCodeIsCalled_thenReturnedTokenIsStored() {
        let authCode = "123"
        network?.eventual(token: token)
        service.askForAccessToken(with: authCode).execute()
        let retrieved = service.accessTokenStorageService.retrieve(tokenFor: service.config)
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved!.accessToken, token.accessToken)
    }

    func test_whenTokenForGivenURLIsNotInStorage_thenIsAuthroizationRequiredReturnsTrue() {
        service.accessTokenStorageService.delete(tokenFor: service.config)
        XCTAssertTrue(service.isAuthorizationRequired())
    }

}


final class OAuthMock: OAuth2 {
    
    var config: OAuth2Config {
        let clientId = "clientId"
        let scopes = ["username", "password"]
        let authServer = URL(string: "www.kandelvijaya.com")!
        let tokenServer = URL(string: "www.bnk.life")!
        let redirectURI = URL(string: "myapp://")!
        let config = OAuth2Config(clientId: clientId, scopes: scopes, authServer: authServer, tokenServer: tokenServer, redirectURI: redirectURI)
        return config
    }

    // Check this out: https://twitter.com/kandelvijaya/status/950055427882016768
    var accessTokenNetworkService: OAuth2NetworkServiceProtocol = MockNetowrk()
}


final class MockNetowrk: OAuth2NetworkServiceProtocol {

    enum MockError: Error {
        case testMockError
    }

    private var token: Result<OAuth2AccessToken> = .failure(MockError.testMockError)

    func eventual(token: OAuth2AccessToken) {
        self.token = .success(token)
    }

    func eventual(error: Error) {
        self.token = .failure(error)
    }

    func post(withRequest urlRequest: URLRequest) -> Future<Result<OAuth2AccessToken>> {
        return Future<Result<OAuth2AccessToken>> { aCompletion in
            aCompletion?(self.token)
        }
    }

}
