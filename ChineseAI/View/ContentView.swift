//
//  ContentView.swift
//  ChineseAI
//
//  Created by Nguyễn Tiến Mai on 23/4/25.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            Text("Welcome to ChineseAI")
        } detail: {
            Text("Select an item")
        }
    }
}

#if DEBUG
@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
