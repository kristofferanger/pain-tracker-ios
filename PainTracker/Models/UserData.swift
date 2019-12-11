/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A model object that stores app data.
*/

import Combine
import SwiftUI



final class UserData: ObservableObject {
    
    @Published var hikes: Hikes = load("hikeData.json", as: Hikes.self)
    @Published var painKillers: PainKillers = load("PainKillers.json", as: PainKillers.self)
}
