//
//  ContentView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-09-04.
//  Copyright © 2019 Kriang. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject private var userData: UserData

    
    @FetchRequest(fetchRequest: PainItem.painItemfetchRequest()) var painItems
    @State private var newPainItem = ""
    
    @State private var showingModal = false

    var body: some View {
    
        NavigationView {
            List() {
                ForEach(userData.hikes) { hike in
                    HikeView(hike: hike)
                }
            }
            .navigationBarTitle("PainTracker")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.showingModal.toggle()
                    }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showingModal) {
                        DetailView(isShowing: self.$showingModal)
                    }
                }
            )
        }
    }
    
    
    
    private func backgroundColor() -> Color  {
        return colorScheme == .dark ? Color(hexValue: ALMOND_COLOR).lighten(-0.1) : Color(hexValue: ALMOND_COLOR).lighten(0.7)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        return UITextView()
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}


struct TableView: UIViewRepresentable {
    
    @Binding var color: String

    
    func makeUIView(context: Context) -> UITableView {
        return UITableView()
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        uiView.backgroundColor = UIColor.clear
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
