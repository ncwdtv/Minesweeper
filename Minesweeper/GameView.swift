//
// GameView.swift
//  Minesweeper
//
//  Created by Nick Deupree on 12/20/23.
//

import SwiftUI
import Combine

struct GameView: View {
    @ObservedObject var game = MinesweeperGame()
    @Environment(\.presentationMode) var presentationMode
    //@State var timer: Timer? = nil
    var ogCellSize: CGFloat = 40
    let controlPanelHeight: CGFloat = 50
    @State private var zoomLevel: Double = 1.0
    @GestureState private var magnification: CGFloat = 1.0
    
    var body: some View {
        
        GeometryReader { geometry in
            let cellSize = min(min(NSScreen.main?.frame.width ?? CGFloat.infinity / CGFloat(game.columns), ((NSScreen.main?.frame.height ?? CGFloat.infinity)-controlPanelHeight-230) / CGFloat(game.rows   )), ogCellSize)
            ZStack {
                VStack {
                    HStack{
                        Text("Mines: \(game.minesSpeculated)").padding()
                        Button(action: {
                            game.generateBoard()
                            game.numRevealed = 0
                            self.game.timeElapsed = 0
                            if game.timer == nil {
                                self.game.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
                                    self.game.timeElapsed += 1
                                }
                            }
                            
                        }) {
                            Text(game.winOrLose == 0 ? "Reset" : game.winOrLose == 1 ? "Lost" : "Won")
                        }.padding()
                        Text("Timer: \(game.timeElapsed)").padding()
                        .frame(width:100,alignment: .leading)
                    }
                    .frame(alignment: .center)
                    //Spacer(minLength: controlPanelHeight)
                    ZStack {
                         Rectangle()
                            .fill(Color.gray)
                            .frame(width: CGFloat(game.columns) * cellSize + CGFloat(game.columns) * 2, 
                                   height: CGFloat(game.rows) * cellSize + CGFloat(game.rows) * 2)
                        VStack(spacing: 0) {
                            ForEach(0..<game.rows, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<game.columns, id: \.self) { column in
                                        CellView(game: game, row: row, column: column, cellWidth: cellSize, cellHeight: cellSize)
                                            .padding(1)
                                    }
                                }
                                .frame(alignment: .center)
                            }
                            .frame(alignment: .center)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .center)
                        .scaleEffect(self.zoomLevel)
                        .animation(.easeInOut(duration: 0.2), value: self.zoomLevel)

                        
                    }
                    Button(action:{
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Text("Back")
                        }.padding()
                    
                }
                .frame(alignment: .center)
                
            }
            
            .gesture(MagnificationGesture()
                .updating($magnification) { currentState, gestureState, transaction in
                    gestureState = currentState
                }
                .onEnded { value in
                    self.zoomLevel *= value
                    if self.zoomLevel > 1.0 {
                        self.zoomLevel = 1.0
                    }
                }
            )
        }
        .frame(maxWidth: NSScreen.main?.frame.width, maxHeight: NSScreen.main?.frame.width, alignment: .center)
        .onAppear {
            if game.rows == 0 && game.columns == 0 && game.mines == 0 {
                game.updateDimensions(r: 9, c: 9, m: 10)
            }
            if !game.isGameInProgress {
                game.generateBoard() // ALLOW USER TO RE-ENTER THEIR GAME
                
                self.game.timer?.invalidate()
                self.game.timer = nil
                self.game.timeElapsed = 0
                self.game.savedTimeElapsed = 0
                self.game.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
                    self.game.timeElapsed += 1
                }
            }else{
                self.game.timeElapsed = self.game.savedTimeElapsed
                self.game.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
                    self.game.timeElapsed += 1
    
            }
            }

            
            
            
        }
        .onDisappear{
            self.game.timer?.invalidate()
            self.game.timer = nil
            self.game.savedTimeElapsed = self.game.timeElapsed
        }.navigationBarBackButtonHidden(true)
    }
    
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

