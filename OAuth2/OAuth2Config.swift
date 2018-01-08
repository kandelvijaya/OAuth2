//
//  Copyright © 2018 zalando.de. All rights reserved.
//

import Foundation

/// A config struct that holds essential information
/// required to make successful OAuth2 synchronization.
public struct OAuth2Config: Codable {

    /// `client_id` is generated during registration of the client app
    var clientId: String

    /// Refer to the provided scope url endpoint
    /// i.e. google developer
    var scopes: [String]

    /// url for authorizationServer without the parameter fields
    var authServer: URL

    /// url for the tokenServer without the parameter fields
    var tokenServer: URL

    /// generated during the registration of the client app
    /// for iOS apps, navigate to info.plist and set the custom url scheme
    /// URLTypes .. URL Schemes and add a entry with this exact redirectURI
    /// When the app's custom scheme doesnot match the redirectURI,
    /// most authorization services will throw a error after authenticating owner
    var redirectURI: URL

    var scopesString: String {
        return scopes.joined(separator: " ").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }

    let grantType = "authorization_code"

}
