//
//  DeveloperProfileView.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import SwiftUI

struct DeveloperProfileView: View {

    @ObservedObject var viewModel: DeveloperProfileViewModel

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            AsyncImage(url: viewModel.profile.avatarUrl) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())

            Text(viewModel.profile.username)
                .font(.title)
                .bold()

            if let bio = viewModel.profile.bio {
                Text("📍 \(bio)")
            }

            HStack {
                VStack {
                    Text("Followers")
                    Text("\(viewModel.profile.followers)")
                }
                VStack {
                    Text("Following")
                    Text("\(viewModel.profile.following)")
                }
                VStack {
                    Text("Repos")
                    Text("\(viewModel.profile.publicRepos)")
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Developer")
    }
}
