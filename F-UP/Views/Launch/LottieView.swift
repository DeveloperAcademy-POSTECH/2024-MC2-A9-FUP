//
//  LottieView.swift
//  F-UP
//
//  Created by LeeWanJae on 5/24/24.
//

import Lottie
import SwiftUI

struct LottieView : UIViewRepresentable {
    typealias UIViewType = UIView
    
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIViewType(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.play(toProgress: 1, loopMode: LottieLoopMode.repeat(10)) { isFinished in
            if isFinished {
                print("Animation Completed")
            } else {
                print("Animation Cancled")
            }
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
    }
}

