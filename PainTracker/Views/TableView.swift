//
//  TableView.swift
//  PainTracker
//
//  Created by Kristoffer Anger on 2019-10-15.
//  Copyright © 2019 Kriang. All rights reserved.
//


import SwiftUI
import UIKit

fileprivate let alphabet = "ABCDEFGHIJKLMNOPQRSTUVXYZ".map{ String($0) }

struct TableView: UIViewRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItemId: Int?
    
    var data: PainKillers
    
    lazy var painKillersDictionary: [String: PainKillers] = {
        var dictionary = [String: PainKillers]()
        for key in alphabet {
            let items = data.filter{ $0.brand.hasPrefix(key) }
            dictionary.updateValue(items, forKey: key)
        }
        return dictionary
    }()

    func makeUIView(context: UIViewRepresentableContext<TableView>) -> UITableView {
        
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: UIViewRepresentableContext<TableView>) {
        print(context.coordinator)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
        
        var parent: TableView

        init(_ tableView: TableView) {
            parent = tableView
        }
            
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            let items = parent.painKillersDictionary[alphabet[section]]
            return items?.count ?? 0
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return parent.painKillersDictionary.count
        }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let item = parent.painKillersDictionary[alphabet[indexPath.section]]?[indexPath.row]
            
            cell.textLabel?.text = item?.brand
            cell.backgroundColor = .clear
            return cell
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // print(scrollView.description)
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // get selected item and dismisss view
             let item = parent.painKillersDictionary[alphabet[indexPath.section]]?[indexPath.row]
            parent.selectedItemId = item?.id
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return alphabet
        }
        
        deinit {
            print("table view coordinator dealloced")
        }
    }
}


