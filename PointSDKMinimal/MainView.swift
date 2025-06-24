//
//  MainView.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 12/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    @State var navigateToChatAI = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header: Text("SDK"),
                    footer: Text(viewModel.isSDKInitialized ? "SDK is initialized" : "SDK is not initialized")
                ) {
                    HStack(spacing: 12) {
                        Button {
                            viewModel.initializeSDK()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "gearshape.fill")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Initialize SDK")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())

                        Button {
                            viewModel.resetSDK()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "arrow.counterclockwise")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Reset SDK")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())
                    }
                    .padding()
                    .listRowBackground(Color.white)
                    .listRowInsets(EdgeInsets())
                }
                
                Section(header: Text("Geo-triggering"),
                        footer: Text(viewModel.isGeoTriggerRunning ? "Geo-Triggering is running" : "Geo-Triggering is not running")
                    ) {
                    HStack(spacing: 12) {
                        Button {
                            viewModel.startGeoTriggering()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "location.circle")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Start Geo-trigger")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())

                        Button {
                            viewModel.stopGeoTriggering()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "location.slash")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Stop Geo-trigger")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())
                    }
                    .padding()
                    .listRowBackground(Color.white)
                    .listRowInsets(EdgeInsets())
                }
                
                Section(header: Text("Tempo"),
                        footer: Text(viewModel.isTempoRunning ? "Tempo is running" : "Tempo is not running")
                    ) {
                    HStack(spacing: 12) {
                        Button {
                            viewModel.startTempo()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "mappin.and.ellipse")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Start Tempo")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())
                        
                        Button {
                            viewModel.stopTempo()
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "mappin.slash")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                Text("Stop Tempo")
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(UniformButtonStyle())
                    }
                    .padding()
                    .listRowBackground(Color.white)
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    HStack(spacing: 12) {
                        Button {
                            if viewModel.isSDKInitialized {
                                navigateToChatAI = true
                            } else {
                                viewModel.showAlert(title: "Please initialize SDK")
                            }
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: "message.fill")
                                    .frame(width: 24, height: 24)
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.blue)

                                Text("Chat AI")
                            }
                        }
                    }
                    .padding()
                }
                .listRowBackground(Color.white)
                .listRowInsets(EdgeInsets())
            }
            .formStyle(.grouped)
            .navigationTitle("iOS Point SDK")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.openLocationSettings()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .buttonStyle(.plain)
                }
            }
            .onAppear {
                viewModel.requestLocationPermissions()
            }
            .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            message: {
                Text(viewModel.alertMessage)
            }
            .navigationDestination(isPresented: $navigateToChatAI) {
                ChatAIView()
            }
        }
    }
}

// MARK: - Uniform Button Style
struct UniformButtonStyle: ButtonStyle {
    let height: CGFloat = 64

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .frame(minHeight: height)
            .background(Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.clear, lineWidth: 0)
            )
            .cornerRadius(12)
            .foregroundColor(.blue)
    }
}

#Preview {
    MainView()
}
