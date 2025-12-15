//
//  DeveloperProfileView.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import SwiftUI

struct DeveloperProfileView: View {
    let profile: DeveloperProfile

    var body: some View {
        HStack {

            VStack(spacing: 20) {
                AsyncImage(url: profile.avatarUrl) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())

                Text(profile.username).font(.title.bold())

                HStack {
                    VStack {
                        Text("Followers")
                        Text("\(profile.followers)")
                    }
                    VStack {
                        Text("Following")
                        Text("\(profile.following)")
                    }
                    VStack {
                        Text("Repos")
                        Text("\(profile.publicRepos)")
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Developer Profile")
            .foregroundStyle(GitHubTheme.text)
        }
        .background(GitHubTheme.background)
    }
}

//#Preview {
//    DeveloperProfileView(profil: )
//}
