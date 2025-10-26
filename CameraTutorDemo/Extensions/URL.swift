//
//  URL.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation

extension URL {
    static var apiBaseUrl: URL { URL(string: Bundle.main.infoDictionary!["API_BASE_URL"] as! String)! }
}
