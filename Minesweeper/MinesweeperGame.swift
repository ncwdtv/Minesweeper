//
//  ContentView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/19/23.
//

import Foundation
import Combine

class MinesweeperGame: ObservableObject {
    // Add your game logic here
    // Use @Published for properties that should cause the view to update when they change
    

    @Published var difficulty: String = "Easy"
    @Published var rowsString = ""
    @Published var columnsString = ""
    @Published var minesString = ""
    @Published var rows = 0
    @Published var columns = 0
    @Published var mines = 0
    @Published var numRevealed = 0
    static var directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
    @Published var minesSpeculated = 0
    @Published var gameOver = false

    
    @Published var gamesPlayed = 0
    @Published var gamesWon = 0
    @Published var gamesLost = 0
    @Published var winPercentage = 0.0
    @Published var lossPercentage = 0.0
    @Published var averageTime = 0.0
    @Published var fastestTime = 0
    @Published var slowestTime = 0
    @Published var endTime = 0
    @Published var threeBV = 0.0
    @Published var threeBVPerSecond = 0.0
    @Published var iOS = 0.0
    @Published var RPQ = 0.0
    @Published var totalClicks = 0
    @Published var iOE = 0.0
    @Published var correctness = 0.0
    @Published var throughput = 0.0



    @Published var revealedBoard: [[Bool]] = []
    @Published var originalBoard: [[Int]] = []
    @Published var board: [[Int]] = []
    @Published var flagBoard: [[Int]] = []

    var timer: Timer? = nil

    func updateDimensions(r: Int, c: Int, m: Int){
        self.rows = r
        self.columns = c
        self.mines = m

        generateBoard()         //ADDED THIS TO FIX BUG WHERE INDEX OUT OF RANGE IF DIFF SELECTED
    }
    
    func generateBoard() {
    revealedBoard = [[Bool]](repeating: [Bool](repeating: false, count: columns), count: rows)
    originalBoard = [[Int]](repeating : [Int](repeating: 0, count: columns), count: rows)
    board = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
    flagBoard = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
    for _ in 0..<mines{
        var i = Int.random(in: 0..<rows)
        var j = Int.random(in: 0..<columns)
        //check if i and j are in bounds
        while board[i][j] == -1 {
            i = Int.random(in: 0..<rows)
            j = Int.random(in: 0..<columns)
        }
        board[i][j] = -1
    }

    for i in 0..<rows{
        for j in 0..<columns{
            if board[i][j] == -1 {
                continue
            }
            var numMines = 0
            for (di, dj) in MinesweeperGame.directions {
                let newI = i + di
                let newJ = j + dj
                if newI >= 0, newI < rows, newJ >= 0, newJ < columns, board[newI][newJ] == -1 {
                    numMines += 1
                }
            }
            board[i][j] = numMines
        }
    }
    originalBoard = board
   // printBoard(list: board)
    //printBoolBoard(list: revealedBoard)
    gamesPlayed += 1

    minesSpeculated = mines
    }


        //print the array
    func printBoard(list: [[Int]]){
        for i in 0..<rows {
            for j in 0..<columns {
                print(list[i][j], terminator: " ")
            }
            print()
        }
    }
    func printBoolBoard(list: [[Bool]]){
        for i in 0..<rows {
            for j in 0..<columns {
                print(list[i][j], terminator: " ")
            }
            print()
        }
    }

    func printBoardGivenBool(boolList: [[Bool]], board: [[Int]], flagBoard: [[Int]]){
        for i in 0..<rows {
            for j in 0..<columns {
                if boolList[i][j] == true {
                    if(flagBoard[i][j] == -3){
                        print("F", terminator: " ")
                    }else{
                        print(board[i][j], terminator: " ")
                    }
                }
                else {
                    print("_", terminator: " ")
                }
            }
            print()
        }
    }

    func revealAroundMiddleMan(i: Int, j: Int){
        revealAround(i: i, j: j, board: &board, revealed: &revealedBoard)
    }

    func revealAround(i: Int, j: Int, board: inout [[Int]], revealed: inout [[Bool]]){
        //Can make a setting to not allow you to reveal around a square that has unflagged mines
        if revealed[i][j] == false {
            return
        }
        //check if i and j are out of bounds
        if(i < 0 || i >= rows || j < 0 || j >= columns) {
            return
        }

        //check if the current square is touching the correct number of mines
        var numFlags = 0
        for (di, dj) in MinesweeperGame.directions {
            let newI = i + di
            let newJ = j + dj
            if newI >= 0, newI < rows, newJ >= 0, newJ < columns, board[newI][newJ] == -3 {
                numFlags += 1
            }
        }
        if numFlags != board[i][j] {
            return
        }
        //reveal all the squares around the current square
        for (di, dj) in MinesweeperGame.directions {
            let newI = i + di
            let newJ = j + dj
            if newI >= 0, newI < rows, newJ >= 0, newJ < columns, revealed[newI][newJ] == false {
                revealed[newI][newJ] = true
                if(board[newI][newJ] == -1){
                    revealAll(revealed: &revealed)
                    endGame()
                    return
                }
                numRevealed += 1
                checkWin()
            }
        }
    }

    func revealZeroesMiddleMan(i: Int, j: Int, flag: Bool) {
        revealZeros(i: i, j: j, board: &board, revealed: &revealedBoard, originalBoard: originalBoard, flag: flag, numRevealed: &numRevealed)
        checkWin()
    }
    func revealZeros(i: Int, j: Int, board: inout [[Int]], revealed: inout [[Bool]],originalBoard: [[Int]], flag: Bool, numRevealed: inout Int) {
        //reveal the current square and reveal the zeroes around it
        if revealed[i][j] == true && board[i][j] != -3 {
            return
        }

        //if i and j are out of bounds return
        if(i < 0 || i >= rows || j < 0 || j >= columns) {
            return
        }


        if flag {
            if(board[i][j] == -3){
                board[i][j] = originalBoard[i][j]
                minesSpeculated += 1
                if(board[i][j] == 0){
                    revealed[i][j] = true
                }else{
                  revealed[i][j] = false  
                }
            }
            else{
                board[i][j] = -3
                minesSpeculated -= 1
                revealed[i][j] = true
            }
            return
        }else{
            if(board[i][j] == -3){

                minesSpeculated += 1
                board[i][j] = originalBoard[i][j]
            }
            if board[i][j] == -1 {
                revealAll(revealed: &revealed)
                endGame()
                return
            }
        }
        //reveal the current square
        revealed[i][j] = true
        numRevealed += 1
        if board[i][j] == 0 {
            for (di, dj) in MinesweeperGame.directions {
                let newI = i + di
                let newJ = j + dj
                if newI >= 0, newI < rows, newJ >= 0, newJ < columns {
                    //check if board[newI][newJ] is not out of bounds
                    if newI < board.count && newJ < board[newI].count {
                        if(revealed[newI][newJ] == false){
                            revealZeros(i: newI, j: newJ, board: &board, revealed: &revealed, originalBoard: originalBoard, flag: flag, numRevealed: &numRevealed)
                        }
                    }
                }
            }
        }
    }
 



    func calculateWin(board: [[Int]], revealed: [[Bool]]) -> Bool {
        var numRevealed = 0
        for i in 0..<rows {
            for j in 0..<columns {
                if(revealed[i][j] == true){
                    numRevealed += 1
                }
            }
        }
        if(numRevealed == rows * columns && minesSpeculated == mines){
            return true
        }
        return false
    }
    func checkWin(){
        if calculateWin(board: board, revealed: revealedBoard) {
            gamesWon += 1
            print("You Win!")
          //  printBoardGivenBool(boolList: revealedBoard, board: board, flagBoard: flagBoard)
        }
    }
    func endGame(){
        gamesLost += 1
        print("Game Over")
      //  printBoardGivenBool(boolList: revealedBoard, board: board, flagBoard: flagBoard)
        gameOver = true
        timer?.invalidate()
        timer = nil
    }

    func revealAll(revealed: inout [[Bool]]) {
        for i in 0..<rows {
            for j in 0..<columns {
                revealed[i][j] = true
            }
        }
    }
    func printDifficulty() {
        print("Difficulty: \(difficulty)")
    }
    func printBoardDetails() {
        print("Rows: \(rows)")
        print("Columns: \(columns)")
        print("Mines: \(mines)")
    }
}

