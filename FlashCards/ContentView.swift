//
//  ContentView.swift
//  FlashCards
//
//  Created by Mubeen Asif on 19/10/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var deckId: Int = 0
    
    @State private var createCardViewPresented = false
    
    @State private var cards : [Card] = Card.mockedCards
    
    @State private var cardsToPractice: [Card] = [] // <-- Store cards removed from cards array
    
    @State private var cardsMemorized: [Card] = [] // <--
    
    var body: some View {
        ZStack {
            
            // Reset buttons
                VStack { // <-- VStack to show buttons arranged vertically behind the cards
                   Button("Reset") { // <-- Reset button with title and action
                       
                       deckId += 1
                       
                       cards = cardsToPractice + cardsMemorized // <-- Reset the cards array with cardsToPractice and cardsMemorized
                       cardsToPractice = [] // <-- set both cardsToPractice and cardsMemorized to empty after reset
                       cardsMemorized = [] // <--
                   }
                   .disabled(cardsToPractice.isEmpty && cardsMemorized.isEmpty)

                   Button("More Practice") { // <-- More Practice button with title and action
                       
                       deckId += 1
                       
                       cards = cardsToPractice // <-- Reset the cards array with cardsToPractice
                       cardsToPractice = [] // <-- Set cardsToPractice to empty after reset
                   }
                   .disabled(cardsToPractice.isEmpty)
               }
            
            // Cards
            ForEach(0..<cards.count, id: \.self) { index in
                
                CardView(card: cards[index], onSwipedLeft: { // <-- Add swiped left property
                    
                    let removedCard = cards.remove(at: index) // <-- Remove the card from the cards array
                    cardsToPractice.append(removedCard)
                    
                }, onSwipedRight: { // <-- Add swiped right property
                    
                    let removedCard = cards.remove(at: index) // <-- Remove the card from the cards array
                    cardsMemorized.append(removedCard)
                })
                    .rotationEffect(.degrees(Double(cards.count - 1 - index) * -5))
            }
        }
        .animation(.bouncy, value: cards)
        .id(deckId) // <-- Add an id modifier to the main card deck ZStack
        .sheet(isPresented: $createCardViewPresented, content: {
            CreateFlashcardView { card in
                cards.append(card)
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) { // <-- Add an overlay modifier with top trailing alignment for its contents
            Button("Add Flashcard", systemImage: "plus") {  // <-- Add a button to add a flashcard
                createCardViewPresented.toggle() // <-- Toggle the createCardViewPresented value to trigger the sheet to show
            }
        }
    }
}

#Preview{
    ContentView()
}
