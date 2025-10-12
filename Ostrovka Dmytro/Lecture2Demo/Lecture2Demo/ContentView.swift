//
//  ContentView.swift
//  Lecture2Demo
//
//  Created by Dmytro Ostrovka on 06.10.2025.
//

import SwiftUI

struct Animal {
    var paws: Int
    var age: UInt
}

struct ContentView: View {
    @State var counter: Int = 0
    @State var isOn: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            if !isOn {
                Text("Hello, world! \(counter)")
                    .bold()
                    .font(.largeTitle)
            }

            Spacer()
                .frame(height: 20.0)

            Button("HIT ME") {
                counter += 1
                isOn.toggle()
            }

            MyToggleView(isOn: $isOn)
        }
        .padding()
    }
}

struct MyToggleView: View {
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            if isOn {
                Text("Success!")
            } else {
                Text("Toggle me!")
            }
        }
    }
}

#Preview {
    ContentView()
}
