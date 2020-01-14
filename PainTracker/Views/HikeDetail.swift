/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a hike.
*/

import SwiftUI

struct HikeDetail: View {
    let hike: Hike
    @State var dataToShow = \Hike.Observation.elevation
    
    var buttons = [
        ("Mon", \Hike.Observation.elevation),
        ("Tue", \Hike.Observation.elevation),
        ("Wed", \Hike.Observation.elevation),
        ("Thu", \Hike.Observation.elevation),
        ("Fri", \Hike.Observation.elevation),
        ("Sat", \Hike.Observation.elevation),
        ("Sun", \Hike.Observation.elevation)
    ]
    
    var body: some View {
        return VStack {
            HikeGraph(hike: hike, path: dataToShow)
                .frame(height: 200, alignment: .center)
            
            HStack(spacing: 20) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.dataToShow = value.1
                    }) {
                        Text(verbatim: value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == self.dataToShow ? Color.gray : Color.accentColor)
                            .animation(nil)
                    }
                }
            }
        }
    }
}

//struct HikeDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        HikeDetail(hike: hikeData[0])
//    }
//}
