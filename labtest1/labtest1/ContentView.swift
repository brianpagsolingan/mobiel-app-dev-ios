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
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
