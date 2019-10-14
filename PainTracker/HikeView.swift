/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying inforamtion about a hike, including an elevation graph.
*/

import SwiftUI

struct HikeView: View {
    
    var hike: Hike
    
    @State private var showDetail = false
    
    var transition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)
                    .animation(nil)

                VStack(alignment: .leading) {
                    Text(verbatim: hike.weekNumberText)
                        .font(.headline)
                    
                    Text(verbatim: hike.weeklyHightText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(verbatim: hike.weeklyDurestText)
                    .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }

                Spacer()
                    .layoutPriority(-1)

                Button(action: {
                    withAnimation {
                    	self.showDetail.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .foregroundColor(Color(hexValue: WILLPOWER_ORANGE_COLOR))
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                }
            }

            if showDetail {
                HikeDetail(hike: hike)
                	.transition(transition)
            }

        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
                
        return VStack {
            HikeView(hike: hikeData[0])
                .padding()
            Spacer()
        }
    }
}
