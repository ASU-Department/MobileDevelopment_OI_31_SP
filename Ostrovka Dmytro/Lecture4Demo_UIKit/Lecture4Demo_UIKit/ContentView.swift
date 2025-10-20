//
//  ContentView.swift
//  Lecture3Demo
//
//  Created by Dmytro Ostrovka on 13.10.2025.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        TabView {
            Tab("First", systemImage: "tray.and.arrow.down.fill") {
                ContentView()
            }
            .badge(2)


            Tab("Second", systemImage: "tray.and.arrow.up.fill") {
                ListsTest()
            }


            Tab("Third", systemImage: "person.crop.circle.fill") {
                ContentView()
            }
            .badge("!")
        }
    }
}

struct ContentView: View {
    enum Route: String {
        case screenOne
        case screenTwo
        case screenThree
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Hello, world!")
                    .navigationBarTitle("Hello")

                SwiftUIMapView()
                    .frame(width: .infinity, height: 100.0)

                NavigationLink(value: Route.screenOne, label: {
                    Text("Hit me two!")
                })

                NavigationLink(value: Route.screenThree, label: {
                    Text("Hit me THREE!")
                })
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .screenOne:
                    ContentViewScreenTwo()
                case .screenThree:
                    EmptyView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct ContentViewScreenTwo: View {
    @State private var isPresentedSheet: Bool = false
    @State private var isPresentedServerAlert: Bool = false
    @State private var isPresentedConfirmationDialog: Bool = false

    var body: some View {
        VStack {
            Text("New hello, world!")

            Button("Show info") {
                isPresentedSheet.toggle()
            }
            .padding()

            Button("Simulate error") {
                isPresentedServerAlert.toggle()
            }
            .padding()

            Button("Call confirmation dialog") {
                isPresentedConfirmationDialog.toggle()
            }
            .padding()
        }
        .sheet(isPresented: $isPresentedSheet) {
            // TODO: - Handle in next feature
            print("on dimiss")
        } content: {
            SheetContentView()
        }
        .alert("Some server Error!", isPresented: $isPresentedServerAlert) {
            Button("Ok", role: .cancel) {
                print("on button OK")
            }
        }
        .actionSheet(isPresented: $isPresentedConfirmationDialog) {
            ActionSheet(title: Text("Some action sheet"),
                        message: Text("Some message here"),
                        buttons: [
                            .cancel(Text("Cancel")),
                            .destructive(Text("Delete")),
                            .default(Text("OK"))
                        ])
        }
    }
}

struct SheetContentView: View {
    var body: some View {
        VStack {
            Text("Some info 1")
                .padding()
            Text("Some info 2")
                .padding()
                .background(Color.blue)
        }
    }
}

struct ListsTest: View {
    var data: [String] = ["Hello", "World", "This", "Is", "A", "Test", "List", "For", "SwiftUI",
                          "Hello", "World", "This", "Is", "A", "Test", "List", "For", "SwiftUI",
                          "Hello", "World", "This", "Is", "A", "Test", "List", "For", "SwiftUI",
                          "Hello", "World", "This", "Is", "A", "Test", "List", "For", "SwiftUI"]

    var body: some View {
//        ScrollView {
//            LazyVStack {
//                ForEach(data, id: \.self) { item in
//                    Text(item)
//                        .font(Font.largeTitle)
//                        .background(Color.yellow)
//                        .padding()
//                }
//            }
//        }
        List(data, id: \.self) { item in
            NavigationLink(value: ContentView.Route.screenThree, label: {
                Text(item)
                    .font(Font.largeTitle)
                    .background(Color.yellow)
                    .padding()
            })
        }
    }
}

#Preview {
    ContentView()
}
