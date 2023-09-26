//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by GIGL iOS on 13/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingScore = false
    @State private var scoreTitle = ""
    @State private var evaluatedMessage = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userScore = 0
    @State private var numberOfQuestionsAsked = 0
    @State private var hasAnsweredFinalQuestion = false
    var body: some View {
        ZStack {
//                        LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
//                            .ignoresSafeArea()
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button{
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .alert(scoreTitle, isPresented: $isShowingScore) {
                            Button("Continue", action: askQuestion)
                        } message: {
                            if scoreTitle == "Correct" {
                                Text("Your score is \(userScore)")
                            } else {
                                Text("That is the flag of \(countries[number])")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
            }
            .alert(evaluatedMessage, isPresented: $hasAnsweredFinalQuestion) {
                Button("Restart", action: resetGame)
            } message: {
                Text("Your were able to answer \(userScore) questions correctly out of 8 asked.")
            }
            .padding()
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            self.userScore += 1
        } else {
            scoreTitle = "Wrong!"
        }
        isShowingScore = true
        numberOfQuestionsAsked += 1
    }
    
    func askQuestion(){
        if numberOfQuestionsAsked == 8 {
            evaluatedMessage = userScore >= 4 ? "HURRAY!" : "EYYAH!"
            hasAnsweredFinalQuestion = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame(){
        userScore = 0
        numberOfQuestionsAsked = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
