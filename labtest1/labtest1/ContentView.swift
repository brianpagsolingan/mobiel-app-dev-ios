//
//  ContentView.swift
//  labtest1
//
//  Created by Brian Aldrin Pagsolingan on 2026-02-17.
//

import SwiftUI

func isPrime(_ n: Int) -> Bool{
    if n < 2{return false}
    if n == 2{return true}
    if n % 2 == 0 {return false}
    var i = 3
    while i * i <= n{
        if n % i == 0 {return false}
        i += 2
    }
    return true
}

enum Answer{
    case none, correct, wrong
}

struct ContentView: View {
    @State private var currentNumber: Int = Int.random(in: 1...100)
    @State private var answerState: Answer = .none
    @State private var correctCount: Int = 0
    @State private var wrongCount: Int = 0
    @State private var attempCount : Int = 0
    @State private var showSummary: Bool = false
    @State private var timeRemaining: Int = 5
    @State private var timer: Timer? = nil
    @State private var answered: Bool = false
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack(spacing: 0){
                //timer
                HStack{
                    Spacer()
                    Text("⏰ \(timeRemaining)s")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(timeRemaining <= 2 ? .red : .gray)
                        .padding(.trailing, 24)
                        .padding(.top, 16)
                }
                Spacer()
                
                // number display
                Text("\(currentNumber)")
                    .font(.custom("Zapf Chancery", size: 90))
                    .padding(.bottom, 60)
                
                // prime button
                Button(action: {handleAnswer(userSaysPrime: true)}){
                    Text("Prime")
                        .font(.custom("Zapf Chancery", size: 36))
                }
            }
            
        }
        
    }
    private func handleAnswer(userSaysPrime: Bool){
        guard !answered else {return}
        answered = true
        timer?.invalidate()
        
        let correct = isPrime(currentNumber) == userSaysPrime
        withAnimation{
            answerState = correct ? .correct : . wrong
        }
        if correct{ correctCount += 1} else {wrongCount += 1}
        
        }
    }
}

#Preview {
    ContentView()
}
