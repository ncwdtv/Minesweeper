//
//  CellView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/20/23.
//

import Foundation
import SwiftUI

struct CellView: View {
    @ObservedObject var game: MinesweeperGame
    let row: Int 
    let column: Int
    
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    
    
    var body: some View {
        ZStack{
            if(game.revealedBoard[row][column] == false){
                Rectangle()
                    .fill(Color.white)
                    .offset(x:-1,y:-1)
                    .frame(width: cellWidth, height: cellHeight)
                Rectangle()
                    .fill(Color(red: 0.5, green: 0.5, blue: 0.5))
                    .offset(x: 1, y: 1)
                    .frame(width: cellWidth, height: cellHeight)
                Rectangle()
                    .fill(Color(red: 0.75, green: 0.75, blue: 0.75))
                    .frame(width: cellWidth * 0.9, height: cellHeight*0.9)
                     
            } else {
                Rectangle()
                    .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                
            }
        }.frame(width: cellWidth, height: cellHeight)
        
            .onTapGesture(count: 1) {
                // Left click action
                if game.revealedBoard[row][column] == true && game.board[row][column] != -3{
                    game.revealAroundMiddleMan(i: row, j: column)
                }
                game.revealZeroesMiddleMan(i: row, j: column, flag: false)
                
            }
            .onLongPressGesture(minimumDuration: 0.5) {
                // Right click action
                game.revealZeroesMiddleMan(i: row, j: column, flag: true)
            }.overlay(
                Group {
                    if row < game.board.count && column < game.board[row].count {
                        if(game.revealedBoard[row][column] == true){
                            // * for bomb ` for flag 
                            switch game.board[row][column] {
                            case -1:
                                Text("*")
                                    .foregroundColor(.red) // Set text color to red
                                    .font(.custom("mine-sweeper", size: 20))
                            case -3:
                                Text("`")
                                    .foregroundColor(.red) // Set text color to green
                                    .font(.custom("mine-sweeper", size: 20))
                            case 1:
                                Text("1")
                                    .foregroundColor(.blue) // Set text color to blue
                                    .font(.custom("mine-sweeper", size: 20))
                            case 2:
                                Text("2")
                                    .foregroundColor(.green) // Set text color to green
                                    .font(.custom("mine-sweeper", size: 20))
                            case 3:
                                Text("3")
                                    .foregroundColor(.red) // Set text color to red
                                    .font(.custom("mine-sweeper", size: 20))
                            case 4:
                                Text("4")
                                    .foregroundColor(.purple) // Set text color to purple
                                    .font(.custom("mine-sweeper", size: 20))
                            case 5:
                                Text("5")
                                    .foregroundColor(.brown) // Set text color to orange
                                    .font(.custom("mine-sweeper", size: 20))
                            case 6:
                                Text("6")
                                    .foregroundColor(.cyan) // Set text color to orange
                                    .font(.custom("mine-sweeper", size: 20))
                            case 7:
                                Text("7")
                                    .foregroundColor(.black) // Set text color to orange
                                    .font(.custom("mine-sweeper", size: 20))
                            case 8:
                                Text("8")
                                    .foregroundColor(.gray) // Set text color to orange
                                    .font(.custom("mine-sweeper", size: 20))
                            case 0:
                                Text("")
                                    .background(Color.gray) // Set background color to gray
                                
                            default:
                                Text("")
                                //.padding(2)
                                    .foregroundColor(.black) // Set text color to black
                                
                            }
                        } else {
                            Text("")
                            //.padding(2)
                                .foregroundColor(.black) // Set text color to black
                        }
                    } else {
                        Text("I")
                            .foregroundColor(.black) // Set text color to black
                    }
                }
            )
        
        
        
    }
    
}

