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
struct ChildSection {
    
    init() {}
    
    @ObservableState
    struct State: Identifiable {
        var id: UUID
        let title: String
        
        var rows: IdentifiedArrayOf<ChildRow.State>
        
        init(id: UUID = UUID(), title: String, rows: IdentifiedArrayOf<ChildRow.State>) {
            self.id = id
            self.title = title
            self.rows = rows
        }
    }
    
    enum Action {
        case rows(IdentifiedActionOf<ChildRow>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .rows:
                return .none
            }
        }
        .forEach(\.rows, action: \.rows) {
            ChildRow()
        }
    }
}

struct ChildSectionView: View {
    private let store: StoreOf<ChildSection>
    
    init(store: StoreOf<ChildSection>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            Section(
                header: Text(store.title)
            ) {
                ForEach(
                    store.scope(state: \.rows, action: \.rows),
                    id: \.state.id
                ) { store in
                    ChildRowView(store: store)
                }
            }
        }
    }
}
