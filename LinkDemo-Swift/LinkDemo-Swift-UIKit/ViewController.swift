//
//  ViewController.swift
//  LinkDemo-Swift
//
//  Copyright © 2019 Plaid Inc. All rights reserved.
//

import UIKit

// <!-- SMARTDOWN_IMPORT_LINKKIT -->
import LinkKit
// <!-- SMARTDOWN_IMPORT_LINKKIT -->

protocol LinkOAuthHandling {
    var linkHandler: Handler? { get }
}

class ViewController: UIViewController, LinkOAuthHandling {

    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var buttonContainerView: UIView!
    var linkHandler: Handler?

    // MARK: - PublicKey Configuration (Deprecated)
    // See `ViewController+PublicKey.swift` for usage of `oauthRedirectUri` & `oauthNonce`.
    // Integrating LinkKit using public key has been deprecated in favor of Link Tokens
    // hence the public key related oauthNonce and oauthRedirect properties are deprecated as well.
    // For more information on how to migrate to Link Tokens see https://plaid.com/docs/link/link-token-migration-guide/

    // When re-initializing Link to complete the OAuth flows ensure that the same oauthNonce is used per session.
    // This is a simplified example for demonstaration purposes only.
    let oauthNonce = UUID().uuidString

    #warning("Replace <#YOUR_OAUTH_REDIRECT_URI#> below with your oauthRedirectUri, which should be a universal link and must be configured in the Plaid developer dashboard")
    let oauthRedirectURI =  URL(string: "<#YOUR_OAUTH_REDIRECT_URI#>")

    // MARK: - Implementation

    override func viewDidLoad() {
        super.viewDidLoad()
        let linkKitBundle  = Bundle(for: PLKPlaid.self)
        let linkKitVersion = linkKitBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let linkKitBuild   = linkKitBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String)!
        let linkKitName    = linkKitBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String)!
        label.text         = "Swift 5 — \(linkKitName) \(linkKitVersion)+\(linkKitBuild)"

        let shadowColor    = #colorLiteral(red: 0.01176470588, green: 0.1921568627, blue: 0.337254902, alpha: 0.1)
        buttonContainerView.layer.shadowColor   = shadowColor.cgColor
        buttonContainerView.layer.shadowOffset  = CGSize(width: 0, height: -1)
        buttonContainerView.layer.shadowRadius  = 2
        buttonContainerView.layer.shadowOpacity = 1
    }

    @IBAction func didTapButton(_ sender: Any?) {
        enum PlaidLinkUILayer {
            case UIKit
            @available(iOS 13.0, *)
            case swiftUI
        }
        enum PlaidLinkSampleFlow {
            case linkToken
            case linkPublicKey // for compatability with LinkKit v1
        }
        #warning("Select your desired Plaid Link sample flow and UI layer")
        let tuple: (PlaidLinkSampleFlow, PlaidLinkUILayer) = (flow: /*@START_MENU_TOKEN@*/.linkToken/*[[".linkToken",".linkPublicKey"],[[[-1,0],[-1,1]]],[0]]@END_MENU_TOKEN@*/, ui: /*@START_MENU_TOKEN@*/.UIKit/*[[".swiftUI",".UIKit"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/)
        switch tuple {
            case (.linkToken, .UIKit):
                presentPlaidLinkUsingLinkToken()
            case (.linkToken, .swiftUI):
                if #available(iOS 13.0, *) {
                    presentSwiftUILinkToken()
                } else {
                    assertionFailure("SwiftUI requires iOS 13 or above")
                }
            case (.linkPublicKey, .UIKit):
                presentPlaidLinkUsingPublicKey()
            case (.linkPublicKey, .swiftUI):
                if #available(iOS 13.0, *) {
                    presentSwiftUIPublicKey()
                } else {
                    assertionFailure("SwiftUI requires iOS 13 or above")
                }
        }
    }
}