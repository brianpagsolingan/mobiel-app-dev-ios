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
    @State private var attemptCount : Int = 0
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
                .disabled(answered)
                .padding(.bottom, 24)
                
                // not prime
                Button(action: {handleAnswer(userSaysPrime: false)}){
                    Text("Not Prime")
                        .font(.custom("Zapf Chancery", size: 36))
                }
                .disabled(answered)
                
                // result icon
                ZStack{
                    if answerState == .correct{
                        Image(systemName: "checkmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color.green)
                            .transition(.scale.combined(with: .opacity))
                    }else if answerState == .wrong{
                        Image(systemName: "xmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(Color.red)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 100)
                .animation(.spring(response: 0.4, dampingFraction: 0.6),value: answerState)
                Spacer()
                
                // score
                
                HStack{
                    Text("✅ \(correctCount)     ❌ \(wrongCount)")
                        .font( .system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.gray)
                        .padding(.leading, 24)
                        .padding(.bottom, 20)
                }
                Spacer()
                Text("Attempt \(attemptCount)")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.trailing, 24)
                    .padding(.bottom, 20)
                
            }
            
        }
        .onAppear{startTimer()}
        .alert("Round Complete! ", isPresented: $showSummary){
            Button("Play Again"){
                correctCount = 0
                wrongCount = 0
                showSummary = false
                nextNumber()
            }
        } message:{
           Text( "Your score is: \(correctCount) / 10")
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
        attemptCount += 1
        
        checkMilestone()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
            if !showSummary{
                nextNumber()
            }
        }
        
        }
    
    private func checkMilestone(){
        if attemptCount % 10 == 0{
            showSummary = true
        }
    }
    
    private func nextNumber(){
        withAnimation{
            answerState = .none
        }
        answered = false
        currentNumber = Int.random(in: 1...100)
        timeRemaining = 5
        startTimer()
    }
    
    private func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            if timeRemaining > 1{
                timeRemaining -= 1
            }else{
                // ran out of time
                timer?.invalidate()
                answered = true
                withAnimation{
                    answerState = .wrong
                }
                wrongCount += 1
                attemptCount += 1
                checkMilestone()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    if !showSummary{nextNumber()}
                }
            }
            
        }
    }
    }


#Preview {
    ContentView()
}
