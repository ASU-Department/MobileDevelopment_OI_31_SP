//
//  ContentView.swift
//  lab1
//
//  Created by Pab1m on 18.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State var counter: Int = 0
    @State var showToast: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Space Explorer")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Image("nasa")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 200)
                    .foregroundColor(.purple)
                
                Text("Rate the astronomical picture of the day")
                
                HStack {
                    Button {
                        if counter > 0 {
                            counter -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    
                    Text("\(counter)")
                        .frame(width: 60)
                    
                    Button {
                        if counter < 10 {
                            counter += 1
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                .imageScale(.large)
                .font(.system(size: 30))
                .foregroundStyle(.tint)
                .padding(.vertical, 20)
                
                Button("Send") {
                    showToast = true
                    counter = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showToast = false
                        }
                    }
                }
                .font(.title2.bold())
                .padding(.all, 10)
                .padding(.horizontal, 40)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Spacer()
                
                HStack {
                    Image(systemName: "cloud.sun")
                    Spacer()
                    Image(systemName: "airplane")
                }
                .font(.system(size: 30))
                .foregroundStyle(.tint)
                .padding(.horizontal, 60)
                .padding(.bottom)
            }
            .padding()
            
            if showToast {
                VStack {
                    Spacer()
                    Text("Rating sent")
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 80)
                        .shadow(radius: 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.easeInOut(duration: 0.3), value: showToast)
            }
        }
    }
}

#Preview {
    ContentView()
}

