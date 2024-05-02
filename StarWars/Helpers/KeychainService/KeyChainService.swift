//
//  MKKeyChain.swift
//  VpnTest
//
//  Created by app on 8/31/23.
//

import Foundation
import Security

class KeyChainService {
    // Function to save a string to the Keychain
    func saveStringToKeychain(_ value: String, forKey key: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            // Delete any existing item
            SecItemDelete(query as CFDictionary)
            
            // Add the new item
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                print("Failed to save to keychain. Error: \(status)")
                return false
            }
            
            print("String saved to keychain successfully.")
            return true
        }
        return false
    }

    // Function to retrieve a string from the Keychain
    func getStringFromKeychain(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("Failed to retrieve from keychain. Error: \(status)")
            return nil
        }
        
        if let data = result as? Data,
           let stringValue = String(data: data, encoding: .utf8) {
            return stringValue
        }
        
        return nil
    }
}



