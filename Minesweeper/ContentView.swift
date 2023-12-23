//
//  ContentView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/19/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var game = MinesweeperGame()
    var body: some View {
        NavigationStack{
            VStack {
                Text("Minesweeper") // Add header text
                    .font(.title)
                    .padding()
                
               NavigationLink(destination: GameView(game : game)) {
                    Text("Play")
                }
                .padding()
                
                NavigationLink(destination: SettingsView(game : game)) {
                    Text("Settings")
                }
                .padding()
                
                //NavigationLink(destination: StatisticsView(game : game)){
                //    Text("Statistics")
                //}
                //.padding()
                
                Button(action: {
                    //Quit the app
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Exit")
                }
                .padding()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // This will center the VStack
                
            Spacer(minLength: 0) // This will push the content to the top
        }   
        }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
