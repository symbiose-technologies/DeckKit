//
//  FavoriteContext.swift
//  DeckKit
//
//  Created by Daniel Saidi on 2020-09-17.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This observable object can be used to bind favorite state
 to your views.
 */
public class FavoriteContext<Item: Favoritable>: ObservableObject, FavoriteService {
    
    public init(service: FavoriteService) {
        self.service = service
        self.favorites = getFavorites(for: Item.self)
    }
    
    private let service: FavoriteService
    
    @Published var favorites: [Item.ID] = []
    
    public func getFavorites<Item: Favoritable>(for type: Item.Type) -> [Item.ID] {
        service.getFavorites(for: Item.self)
    }
    
    public func isFavorite<Item: Favoritable>(_ item: Item) -> Bool {
        service.isFavorite(item)
    }
    
    public func setIsFavorite<ItemType: Favoritable>(_ isFavorite: Bool, for item: ItemType) {
        service.setIsFavorite(isFavorite, for: item)
        favorites = getFavorites(for: ItemType.self) as? [Item.ID] ?? []
    }
}
