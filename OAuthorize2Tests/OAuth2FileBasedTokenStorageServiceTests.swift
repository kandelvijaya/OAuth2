//
//  Copyright © 2018 zalando.de. All rights reserved.
//

import XCTest
@testable import OAuthorize2

final class OAuth2FileBasedTokenStorageServiceTests: XCTestCase {

    private let storage = OAuth2FileBasedAccessTokenStorageService()

    private func oauth2Config(with authUrl: String = "www.bnk.life", withScopes scopes: [String] = ["a", "b"]) -> OAuth2Config {
        let authServer = URL(string: authUrl) ?? URL(string: "www.google.com")!
        let tokenServer = URL(string: "www.kandelvijaya.com")!
        let redirectURI = URL(string: "myapp://")!
        return OAuth2Config(clientId: "clientId", scopes: scopes, authServer: authServer, tokenServer: tokenServer, redirectURI: redirectURI)
    }

    private func token(with accessTokenCode: String = "AccessToken") -> OAuth2AccessToken {
        return OAuth2AccessToken(accessToken: accessTokenCode, tokenType: "kind", expiresIn: 123, refreshToken: "refreshToken")
    }

    func test_whenTokenIsStoredForAUrl_ItCanBeRetrieved() {
        let config = oauth2Config()
        let token = self.token()
        storage.store(token: token, for: config)
        let tokenOut = storage.retrieve(tokenFor: config)
        XCTAssertNotNil(tokenOut)
        XCTAssertEqual(tokenOut!.accessToken, token.accessToken)
    }

    func test_whenTokenIsDeleted_thenItCannotBeRetrieved() {
        let config = oauth2Config()
        let token = self.token()
        storage.store(token: token, for: config)
        storage.delete(tokenFor: config)
        let tokenOut = storage.retrieve(tokenFor: config)
        XCTAssertNil(tokenOut)
    }

    func test_whenSimilarConfigStoresMultipleTokens_eachOneIsUniquelyPersisted() {
        let config1 = oauth2Config(with: "www.facebook.com", withScopes: ["profile", "picture"])
        let token1 = token(with: "fbAccessCode")
        let config2 = oauth2Config(with: "www.facebook.com", withScopes: ["profile", "email"])
        let token2 = token(with: "fbAccessCode2")

        storage.store(token: token1, for: config1)
        storage.store(token: token2, for: config2)

        let outTk1 = storage.retrieve(tokenFor: config1)
        let outTk2 = storage.retrieve(tokenFor: config2)

        XCTAssertNotNil(outTk1)
        XCTAssertNotNil(outTk2)
        XCTAssertNotEqual(outTk1!.accessToken, outTk2!.accessToken)
        XCTAssertEqual(outTk1!.accessToken, "fbAccessCode")
    }
    
}
