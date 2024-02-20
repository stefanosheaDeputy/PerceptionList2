//
//  Child.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 21/2/2024.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct ChildSection {
    
    public init() {}
    
    @ObservableState
    public struct State: Identifiable {
        public var id: UUID
        let title: String
        
        public init(id: UUID = UUID(), title: String) {
            self.id = id
            self.title = title
        }
    }
    
    public enum Action {
        case action
    }
}

public struct ChildView: View {
    private let store: StoreOf<ChildSection>
    
    public init(store: StoreOf<ChildSection>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            Text(store.title)
        }
    }
}
