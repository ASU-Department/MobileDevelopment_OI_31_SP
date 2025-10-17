//
//  ContentView.swift
//  Lr1NewsHub
//
//  Created by Pavlo on 17.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("News Hub")
                .font(.title)
                .bold()
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
