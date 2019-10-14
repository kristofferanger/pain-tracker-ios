/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for a hike.
*/

import SwiftUI

struct Hike: Codable, Identifiable {
    var name: String
    var id: Int
    var distance: Double
    var difficulty: Int
    var observations: [Observation]
    var date: Date

    static var lengthFormatter = LengthFormatter()
    static var dateFormatter = DateFormatter()
    
    var distanceText: String {
        return Hike.lengthFormatter
            .string(fromValue: distance, unit: .kilometer)
    }
    
    var weekNumberText: String {
        let calendar = NSCalendar.current
        let component = calendar.component(.weekOfYear, from: date)
        return "Week \(component)"
    }
    
    var dayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    var weeklyHightText: String {
        let rangeArray = observations.sorted(by: { $0.elevation.upperBound > $1.elevation.upperBound })
        let highestValue = rangeArray.first?.elevation.upperBound ?? 0
        return String(format: "Highest: %.1f", highestValue/100)
    }
//
    var weeklyDurestText: String {
        let rangeArray = observations.sorted(by: { $0.elevation.upperBound-$0.elevation.lowerBound > $1.elevation.upperBound-$1.elevation.lowerBound })
        let highestValue = (rangeArray.first?.elevation.upperBound ?? 0) - (rangeArray.first?.elevation.lowerBound ?? 0)
        return String(format: "Durest: %@", minutesText(from: highestValue * 50))
    }
    
    private func minutesText(from interval: Double) -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour]
        formatter.unitsStyle = .short
        let returnValue = formatter.string(from: TimeInterval(interval)) ?? ""
        return returnValue
    }

    
    // nested struct
    struct Observation: Codable, Hashable {
        var distanceFromStart: Double
        
        var elevation: Range<Double>
        var pace: Range<Double>
        var heartRate: Range<Double>
    }
}

