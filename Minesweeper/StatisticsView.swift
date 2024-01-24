//
//  StatisticsView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/22/23.
//

import Foundation
import SwiftUI

struct StatisticsView: View {
    @ObservedObject var game: MinesweeperGame
    @Environment(\.presentationMode) var presentationMode

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func resetStatistics() {
        // Get the file paths
        let filename = self.getDocumentsDirectory().appendingPathComponent("prevGame.txt")
        let filename2 = self.getDocumentsDirectory().appendingPathComponent("globalStats.txt")

        do {
            // Write an empty string to the files
            try "".write(to: filename, atomically: true, encoding: .utf8)
            try "".write(to: filename2, atomically: true, encoding: .utf8)
        } catch {
            print("Unable to reset saved data.")
        }
        //change the text in the view
        game.endTime = 0
        game.threeBV = 0
        game.threeBVPerSecond = 0
        game.iOS = 0
        game.RPQ = 0
        game.iOE = 0
        game.correctness = 0
        game.throughput = 0
        game.gamesPlayed = 0
        game.gamesWon = 0
        game.gamesLost = 0
        game.winPercentage = 0
        game.lossPercentage = 0
        game.averageTime = 0
        game.fastestTime = 0
        game.slowestTime = 0
    }

    var body: some View {
        NavigationStack{
            VStack{
                Spacer(minLength: 0)
                Text("Statistics")
                    .font(.title)
                    .padding()

                Text("Prev Game Statistics")
                    .font(.headline)
                    .padding()
                Text("Time: \(game.endTime)")
                    .padding(0.5)
                Text("3BV: \(game.threeBV)")
                    .padding(0.5)
                Text("3BV/s: \(game.threeBVPerSecond)")
                    .padding(0.5)
                Text("iOS: \(game.iOS)")
                    .padding(0.5)
                Text("RPQ: \(game.RPQ)")
                    .padding(0.5)
                Text("IOE: \(game.iOE)")
                    .padding(0.5)
                Text("Correctness: \(game.correctness)")
                    .padding(0.5)
                Text("Throughput: \(game.throughput)")
                    .padding(0.5)

                Text("Global Statistics")
                    .font(.headline)
                    .padding()
                Text("Games Played: \(game.gamesPlayed)")
                    .padding(0.5)
                Text("Games Won: \(game.gamesWon)")
                    .padding(0.5)
                Text("Games Lost: \(game.gamesLost)")
                    .padding(0.5)
                Text("Win Percentage: \(game.winPercentage)")
                    .padding(0.5)
                Text("Loss Percentage: \(game.lossPercentage)")
                    .padding(0.5)
                Text("Average Time: \(game.averageTime)")
                    .padding(0.5)
                Text("Fastest Time: \(game.fastestTime)")
                    .padding(0.5)
                Text("Slowest Time: \(game.slowestTime)")
                    .padding(0.5)
                Spacer(minLength:0)
                
                Button(action: {
                    //reset the statistics
                    resetStatistics()
                }) {
                    Text("Reset Statistics")
                }.padding()

                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                }.padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }.onAppear{
        if game.endTime == 0 && game.threeBV == 0 && game.threeBVPerSecond == 0 && game.iOS == 0 && game.RPQ == 0 && game.iOE == 0 && game.correctness == 0 && game.throughput == 0 {
            //get the previous game statistics from the file
            let filename = self.getDocumentsDirectory().appendingPathComponent("prevGame.txt")
            do {
                let input = try String(contentsOf: filename)
                let lines = input.components(separatedBy: "\n")
                if lines.count >= 8 {
                    game.endTime = Int(lines[0]) ?? 0
                    game.threeBV = Double(lines[1]) ?? 0
                    game.threeBVPerSecond = Double(lines[2]) ?? 0
                    game.iOS = Double(lines[3]) ?? 0
                    game.RPQ = Double(lines[4]) ?? 0
                    game.iOE = Double(lines[5]) ?? 0
                    game.correctness = Double(lines[6]) ?? 0
                    game.throughput = Double(lines[7]) ?? 0
                }
            } catch {
                print("Unable to load saved data.")
            }   
        }

        //check if globalStats file is empty
        let filename2 = self.getDocumentsDirectory().appendingPathComponent("globalStats.txt")
        do {
            let input = try String(contentsOf: filename2)
            let lines = input.components(separatedBy: "\n")
            if lines.count >= 9 {
                game.gamesPlayed = Int(lines[0]) ?? 0
                game.gamesWon = Int(lines[1]) ?? 0
                game.gamesLost = Int(lines[2]) ?? 0
                game.winPercentage = Double(lines[3]) ?? 0
                game.lossPercentage = Double(lines[4]) ?? 0
                game.averageTime = Double(lines[5]) ?? 0
                game.fastestTime = Int(lines[6]) ?? 0
                game.slowestTime = Int(lines[7]) ?? 0
            }
        } catch {
            print("Unable to load saved data.")
        }


    }
    }
}
