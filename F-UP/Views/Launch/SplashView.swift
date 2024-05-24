//
//  SplashView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/24/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isSplashScreen = true
    var body: some View {
        ZStack {
            Group {
                if isSplashScreen {
                    SplashScreen()
                } else {
                    ContentTabView()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isSplashScreen = false
                    }
                }
            }
        }
    }
}

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            LottieView(fileName: "Lunch")
        }
        .frame(width:179, height:146)
    }
}
