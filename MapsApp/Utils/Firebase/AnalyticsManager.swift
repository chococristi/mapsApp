//
//  AnalyticsManager.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 28/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsManager {

    static func sendEvent(id: String, name: String, content: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: id,
        AnalyticsParameterItemName: name,
        AnalyticsParameterContentType: content
        ])
    }
}
