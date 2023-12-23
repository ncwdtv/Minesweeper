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
                    .padding()
                Text("3BV: \(game.threeBV)")
                    .padding()
                Text("3BV/s: \(game.threeBVPerSecond)")
                    .padding()
                Text("iOS: \(game.iOS)")
                    .padding()
                Text("RPQ: \(game.RPQ)")
                    .padding()
                Text("IOE: \(game.iOE)")
                    .padding()
                Text("Correctness: \(game.correctness)")
                    .padding()
                Text("Throughput: \(game.throughput)")
                    .padding()

                Text("Global Statistics")
                    .font(.headline)
                    .padding()
                Text("Games Played: \(game.gamesPlayed)")
                    .padding()
                Text("Games Won: \(game.gamesWon)")
                    .padding()
                Text("Games Lost: \(game.gamesLost)")
                    .padding()
                Text("Win Percentage: \(game.winPercentage)")
                    .padding()
                Text("Loss Percentage: \(game.lossPercentage)")
                    .padding()
                Text("Average Time: \(game.averageTime)")
                    .padding()
                Text("Fastest Time: \(game.fastestTime)")
                    .padding()
                Text("Slowest Time: \(game.slowestTime)")
                    .padding()

                Button(action: {
                    //Quit the app
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Exit")
                }
                .padding()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}
