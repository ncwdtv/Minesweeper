//
//  SettingsView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/19/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @ObservedObject var game: MinesweeperGame
    
    @State private var isCustom: Bool = false
    @State private var selectedDifficulty: String = ""
    var body: some View {
        NavigationStack{
            VStack{
                Spacer(minLength: 0)
                Text("Settings")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    game.difficulty = "Easy"
                    game.rowsString = "9"
                    game.columnsString = "9"
                    game.minesString = "10"
                    //call a func in game to update rows, columns, and mines
                    game.updateDimensions(r:9,c:9,m:10)
                    self.isCustom = false
                    if selectedDifficulty != "Easy"{
                        selectedDifficulty = "Easy"
                    }else{
                        selectedDifficulty = ""
                    }
                }) {
                    Text("Easy")
                }
                .background(selectedDifficulty == "Easy" ? .blue : Color.clear)
                .foregroundColor(.white)
                .cornerRadius(2)
                .padding()
                
                Button(action: {
                    game.difficulty = "Medium"
                    game.rowsString = "16"
                    game.columnsString = "16"
                    game.minesString = "40"
                    game.updateDimensions(r: 16, c: 16, m: 40)
                    self.isCustom = false
                    if selectedDifficulty != "Medium"{
                        selectedDifficulty = "Medium"
                    }
                    else{
                        selectedDifficulty = ""
                    }
                }) {
                    Text("Medium")
                }
                .background(selectedDifficulty == "Medium" ? .blue : Color.clear)
                .foregroundColor(.white)
                .cornerRadius(2)
                .padding()
                
                Button(action: {
                    game.difficulty = "Hard"
                    game.rowsString = "30"
                    game.columnsString = "16"
                    game.minesString = "99"
                    game.updateDimensions(r: 16, c: 30, m: 99)
                    self.isCustom = false
                    if selectedDifficulty != "Hard"{
                        selectedDifficulty = "Hard"
                    }
                    else{
                        selectedDifficulty = ""
                    }
                }) {
                    Text("Hard")
                }
                .background(selectedDifficulty == "Hard" ? .blue : Color.clear)
                .foregroundColor(.white)
                .cornerRadius(2)
                .padding()

                Button(action: {
                    self.isCustom.toggle()
                    if selectedDifficulty != "Custom"{
                        selectedDifficulty = "Custom"
                    }
                    else{
                        selectedDifficulty = ""
                    }
                    if isCustom{
                        game.rowsString = ""
                        game.columnsString = ""
                        game.minesString = ""
                    }
                }){
                    Text("Custom")
                }
                .background(selectedDifficulty == "Custom" ? .blue : Color.clear)
                .foregroundColor(.white)
                .cornerRadius(2)
                .padding()

                if isCustom {
                    TextField("Enter custom rows",text: $game.rowsString)
                        .frame(width: 200)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Enter custom columns",text: $game.columnsString)
                        .frame(width: 200)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Enter custom mines",text: $game.minesString)
                        .frame(width: 200)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if let rows = Int(game.rowsString),
                           let columns = Int(game.columnsString),
                           let mines = Int(game.minesString) {
                            game.updateDimensions(r: rows, c: columns, m: mines)
                        }
                    }) {
                        Text("Apply Custom Settings")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(2)
                }
                
                NavigationLink{
                    ContentView(game: game)
                } label: {
                    Text("Back")
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // This will center the VStack
                
                Spacer(minLength: 0) // This will push the content to the top
            }
        }        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(game: MinesweeperGame())
    }
}
