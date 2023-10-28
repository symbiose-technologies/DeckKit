//
//  ContentView.swift
//  DeckKitDemo
//
//  Created by Daniel Saidi on 2020-09-22.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import DeckKit
import SwiftUI

struct ContentView: View {

    @State
    var deck = Deck(
        name: "Hobbies",
        items: Hobby.demoCollection
    )

    @State
    var selectedHobby: Hobby?

    @StateObject
    var animation = DeckShuffleAnimation()
    
    var bodyOG: some View {
        NavigationView {
            #if os(macOS)
            EmptyView()
            #endif
            VStack(spacing: 50) {
                deckView.withPlatformPadding()
                shuffleButton
            }
            .sheet(item: $selectedHobby) {
                HobbyCardContent(item: $0, inSheet: true)
            }
            .navigationTitle("DeckKit")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .padding()
            .background(background)
        }
    }
    
    var body: some View {
        NavigationView {
            #if os(macOS)
            EmptyView()
            #endif
            VStack(spacing: 50) {
                imessageDeckView.imessagePadding()
                shuffleButton
            }
            
            
            .navigationTitle("DeckKit")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .padding()
            .background(background)
        }
    }
    
}

private extension ContentView {

    var imessageDeckView: some View {
        DynamicDeckView(
            deck: $deck,
            config: .init(
                direction: .down,
                itemDisplayCount: 8,
                iMessageMediaStyle: true,
                dragFixedHorizontally: true
            ),
            swipeLeftAction: { hobby in print("\(hobby.id) was swiped left") },
            swipeRightAction: { hobby in print("\(hobby.id) was swiped left") },
            swipeUpAction: { hobby in print("\(hobby.id) was swiped up") },
            swipeDownAction: { hobby in print("\(hobby.id) was swiped down") },
            itemView: card
        )
    }
    
    var deckView: some View {
        DeckView(
            deck: $deck,
            config: .init(
                direction: .down,
                itemDisplayCount: 5
            ),
            swipeLeftAction: { hobby in print("\(hobby.id) was swiped left") },
            swipeRightAction: { selectedHobby = $0 },
            swipeUpAction: { hobby in print("\(hobby.id) was swiped up") },
            swipeDownAction: { hobby in print("\(hobby.id) was swiped down") },
            itemView: card
        )
    }

    var background: some View {
        Color.gray
            .opacity(0.3)
            .edgesIgnoringSafeArea(.all)
    }

    var shuffleButton: some View {
        RoundButton(
            text: "Shuffle",
            image: "shuffle",
            action: { animation.shuffle($deck) }
        )
    }

    func card(for hobby: Hobby) -> some View {
        HobbyCard(item: hobby)
            .withShuffleAnimation(
                animation,
                for: hobby,
                in: deck
            )
    }
}

extension View {
    
    func imessagePadding() -> some View {
        self
//            .padding(.bottom, 50)
            .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
    }
    
    func withPlatformPadding() -> some View {
        #if os(macOS)
        return self.padding(.vertical, 100)
        #else
        return self
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
