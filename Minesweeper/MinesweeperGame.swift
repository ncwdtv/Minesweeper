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
    @Published var isGameInProgress = false
    @Published var savedTimeElapsed = 0
    @Published var timeElapsed = 0
    @Published var winOrLose = 0
    
    
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
    @Published var effectiveClicks = 0
    
    
    
    
    @Published var revealedBoard: [[Bool]] = []
    @Published var originalBoard: [[Int]] = []
    @Published var board: [[Int]] = []
    
    var timer: Timer? = nil
    
    func updateDimensions(r: Int, c: Int, m: Int){
        self.rows = r
        self.columns = c
        self.mines = m
        
        generateBoard()         //ADDED THIS TO FIX BUG WHERE INDEX OUT OF RANGE IF DIFF SELECTED
    }
    
    func generateBoard() {
        totalClicks = 0
        effectiveClicks = 0
        isGameInProgress = true
        revealedBoard = Array(repeating: Array(repeating: false, count: columns), count: rows)
        originalBoard = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        board = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        
        var mineLocations = Set<Int>()
        while mineLocations.count < mines {
            let location = Int.random(in: 0..<(rows * columns))
            mineLocations.insert(location)
        }
        
        for location in mineLocations {
            let i = location / columns
            let j = location % columns
            board[i][j] = -1
            for (di, dj) in MinesweeperGame.directions {
                let newI = i + di
                let newJ = j + dj
                if newI >= 0, newI < rows, newJ >= 0, newJ < columns, board[newI][newJ] != -1 {
                    board[newI][newJ] += 1
                }
            }
        }

        
        
        originalBoard = board
        numRevealed = 0
        minesSpeculated = mines
        winOrLose = 0
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
    
    func revealAround(i: Int, j: Int, board: inout [[Int]], revealed: inout [[Bool]]) {
        if revealed[i][j] == false || i < 0 || i >= rows || j < 0 || j >= columns {
            return
        }
        
        var numFlags = 0
        var cellsToReveal = [(Int, Int)]()
        
        for (di, dj) in MinesweeperGame.directions {
            let newI = i + di
            let newJ = j + dj
            if newI < 0 || newI >= rows || newJ < 0 || newJ >= columns {
                continue
            }
            if board[newI][newJ] == -3 {
                numFlags += 1
            }
            if revealed[newI][newJ] == false {
                cellsToReveal.append((newI, newJ))
            }
        }
        
        if numFlags != board[i][j] {
            return
        }
        
        for (newI, newJ) in cellsToReveal {
            if !revealed[newI][newJ]{
                revealed[newI][newJ] = true
                numRevealed += 1
            }
            if board[newI][newJ] == -1 {
                revealAll(revealed: &revealed)
                endGame()
                return
            }else if board[newI][newJ] == 0 {
                revealZeros(i: newI, j: newJ, board: &board, revealed: &revealed, originalBoard: originalBoard, flag: false, numRevealed: &numRevealed)
            }
            checkWin()
        }
    }
    
    func revealZeroesMiddleMan(i: Int, j: Int, flag: Bool) {
        revealZeros(i: i, j: j, board: &board, revealed: &revealedBoard, originalBoard: originalBoard, flag: flag, numRevealed: &numRevealed)
        checkWin()
    }
    func revealZeros(i: Int, j: Int, board: inout [[Int]], revealed: inout [[Bool]], originalBoard: [[Int]], flag: Bool, numRevealed: inout Int) {
        if revealed[i][j] == true && board[i][j] != -3 || i < 0 || i >= rows || j < 0 || j >= columns {
            return
        }
        
        var queue = [(i, j)]
        while !queue.isEmpty {
            let (i, j) = queue.removeFirst()
            if flag {
                if(board[i][j] == -3){
                    board[i][j] = originalBoard[i][j]
                    //                if board[i][j] == -1{
                    //                    endGame()
                    //                    revealAll(revealed: &revealed)
                    //                    return
                    //                }
                    minesSpeculated += 1
                    revealed[i][j] = false
                    return
                } else {
                    board[i][j] = -3
                    minesSpeculated -= 1
                    revealed[i][j] = true
                }
            } else {
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
            
            if !revealed[i][j] {
            revealed[i][j] = true
            numRevealed += 1
}
            //numRevealed += 1
            //print("incremented numRevealed")
            if board[i][j] == 0 {
                for (di, dj) in MinesweeperGame.directions {
                    let newI = i + di
                    let newJ = j + dj
                    if newI >= 0, newI < rows, newJ >= 0, newJ < columns, newI < board.count, newJ < board[newI].count, revealed[newI][newJ] == false {
                        queue.append((newI, newJ))
                    }
                }
            }
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func updateSavedStats(win: Bool){
        endTime = timeElapsed
        threeBV = Double(calculateThreeBV())
        threeBVPerSecond = threeBV / Double(endTime)
        iOS =  log10(threeBV)/log10(Double(endTime))
        RPQ = Double(endTime) / threeBV
        iOE = threeBV / Double(totalClicks)
        correctness = Double(effectiveClicks) / Double(totalClicks)
        throughput = threeBV / Double(effectiveClicks)
        var str = "\(endTime)\n\(threeBV)\n\(threeBVPerSecond)\n\(iOS)\n\(RPQ)\n\(iOE)\n\(correctness)\n\(throughput)\n)"
        var filename = getDocumentsDirectory().appendingPathComponent("prevGame.txt")
        
        do {    //overwrite
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        //get the previous game statistics from the file
        filename = getDocumentsDirectory().appendingPathComponent("globalStats.txt")
        do {
            let input = try String(contentsOf: filename)
            let lines = input.components(separatedBy: "\n")
            if lines.count >= 8 {
                gamesPlayed = Int(lines[0]) ?? 0
                gamesWon = Int(lines[1]) ?? 0
                gamesLost = Int(lines[2]) ?? 0
                winPercentage = Double(lines[3]) ?? 0
                lossPercentage = Double(lines[4]) ?? 0
                averageTime = Double(lines[5]) ?? 0
                fastestTime = Int(lines[6]) ?? 0
                slowestTime = Int(lines[7]) ?? 0
            }
        } catch {
            print("Unable to load saved data.")
        }
        if(win){
            gamesWon += 1
        } else {
            gamesLost += 1
        }
        gamesPlayed += 1
        winPercentage = Double(gamesWon) / Double(gamesPlayed)
        lossPercentage = Double(gamesLost) / Double(gamesPlayed)
        averageTime = (averageTime * Double(gamesPlayed - 1) + Double(endTime)) / Double(gamesPlayed)
        if((fastestTime == 0 || endTime < fastestTime) && win){
            fastestTime = endTime
        }
        if((slowestTime == 0 || endTime > slowestTime) && win){
            slowestTime = endTime
        }
        str = "\(gamesPlayed)\n\(gamesWon)\n\(gamesLost)\n\(winPercentage)\n\(lossPercentage)\n\(averageTime)\n\(fastestTime)\n\(slowestTime)\n)"
        do {    //overwrite
            try str.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }


        // do { //append
        //     if let fileHandle = FileHandle(forWritingAtPath: filename.path) {
        //         // Seek to the end of the file
        //         fileHandle.seekToEndOfFile()
        //         // Convert your string to Data and write it to the file
        //         if let data = str.data(using: .utf8) {
        //             fileHandle.write(data)
        //         }
        //         // Close the file
        //         fileHandle.closeFile()
        //     } else {
        //         // If the file doesn't exist, create it and write the string to it
        //         try str.write(to: filename, atomically: true, encoding: .utf8)
        //     }
        // } catch {
        //     print("Unable to write to file: \(error)")
        // }
    }
    
    func calculateWin(board: [[Int]], revealed: [[Bool]]) -> Bool {
        let totalSquares = rows * columns
        let nonMineSquares = totalSquares - mines
        return (numRevealed == nonMineSquares && (mines - minesSpeculated) == mines)
    }
    func checkWin(){
        if calculateWin(board: board, revealed: revealedBoard) {
            print("win")
            winOrLose = 2
            timer?.invalidate()
            timer = nil
            isGameInProgress = false
            //  printBoardGivenBool(boolList: revealedBoard, board: board, flagBoard: flagBoard)
            updateSavedStats(win: true)
        }
        //print("no win")
    }
    func endGame(){
        //  printBoardGivenBool(boolList: revealedBoard, board: board, flagBoard: flagBoard)
        gameOver = true
        timer?.invalidate()
        timer = nil
        winOrLose = 1
        isGameInProgress = false
        updateSavedStats(win: false)
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

    func calculateThreeBV() -> Int {
    var t = 0
    var visited = Array(repeating: Array(repeating: false, count: columns), count: rows)

    for i in 0..<rows {
        for j in 0..<columns {
            if !visited[i][j] && board[i][j] >= 0 {
                if board[i][j] == 0 {
                    // This is an opening
                    t += 1
                    dfs(i: i, j: j, visited: &visited)
                } else if isIsolatedNumber(i: i, j: j) {
                    // This is an isolated number
                    t += 1
                    visited[i][j] = true
                }
            }
        }
    }

    return t
}

func dfs(i: Int, j: Int, visited: inout [[Bool]]) {
    if i < 0 || i >= rows || j < 0 || j >= columns || visited[i][j] || board[i][j] < 0 {
        return
    }

    visited[i][j] = true

    if board[i][j] == 0 {
        for (di, dj) in MinesweeperGame.directions {
            dfs(i: i + di, j: j + dj, visited: &visited)
        }
    }
}

func isIsolatedNumber(i: Int, j: Int) -> Bool {
    for (di, dj) in MinesweeperGame.directions {
        let newI = i + di
        let newJ = j + dj
        if newI >= 0 && newI < rows && newJ >= 0 && newJ < columns && board[newI][newJ] == 0 {
            return false
        }
    }
    return true
}

}

