//
//  CryptoListView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 02.11.2025.
//

import SwiftUI

struct CryptoListView: View {
    @StateObject private var viewModel: CryptoListViewModel
    
    init(repository: CoinRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: CryptoListViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredCoins) { coin in
                    NavigationLink(value: coin) {
                        CryptoRowView(coin: coin) {
                            Task {
                                await viewModel.toggleFavorite(for: coin)
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await viewModel.refreshData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("CryptoTracker").font(.headline)

                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.showPortfolioOnly.toggle()
                        }
                    }) {
                        Image(systemName: viewModel.showPortfolioOnly ? "star.fill" : "star")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .accessibilityIdentifier("portfolio_filter_button")
                }
            }
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Link(destination: URL(string: "https://www.coingecko.com?utm_source=CryptoTracker&utm_medium=referral")!) {
                    HStack(spacing: 4) {
                        Text("Data powered by")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Image("coingecko_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 15)
                    }
                    .padding(8)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                }
                .padding(.bottom, 4)
            }
            .task {
                await viewModel.loadData()
            }
            .navigationDestination(for: CoinEntity.self) { coin in
                CoinDetailView(coin: coin)
            }
            .alert(item: $viewModel.errorAlert) { alert in
                Alert(title: Text("Network Error"),
                      message: Text(alert.message),
                      dismissButton: .default(Text("OK")))
            }
            .overlay(alignment: .top) {
                if viewModel.showThrottledMessage {
                    Text("Please wait a moment before refreshing again.")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 4)
                }
            }
        }
    }
}
