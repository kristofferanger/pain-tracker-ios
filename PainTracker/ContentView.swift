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
    @EnvironmentObject private var userData: UserData

    
    @FetchRequest(
        entity: PainItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PainItem.date, ascending: true)]
    ) var painItems: FetchedResults<PainItem>
    
    
    var painTrackingWeeks: [FetchedResults<PainItem>] {
        
        var array = [FetchedResults<PainItem>]()
        for item in painItems {
        }
        return array
    }
    
    @State private var newPainItem = ""
    @State private var showingModal = false

    var body: some View {
    
        NavigationView {
            List {
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
                        DetailView()
                            .environment(\.managedObjectContext, self.managedObjectContext)
                            .environmentObject(self.userData)
                    }
                }
            )
        }
    }
    
    init(){
        UITableView.appearance().backgroundColor = Color.backgroundColor().uiColor()
        UINavigationBar.appearance().barTintColor = Color.backgroundColor().uiColor()
        UITableViewCell.appearance().backgroundColor = .clear
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
