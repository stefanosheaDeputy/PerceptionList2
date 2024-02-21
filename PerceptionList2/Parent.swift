//
//  Parent.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 21/2/2024.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct Parent {
    
    init() {}
    
    @Dependency(\.service) var service
    
    @ObservableState
    struct State {
        var sections: IdentifiedArrayOf<ChildSection.State> = []
        
        func sections(rows: [ChildRow.State]) -> IdentifiedArrayOf<ChildSection.State> {
            return IdentifiedArrayOf(
                uniqueElements: rows.group(),
                id: \.id
            )
        }
    }
    
    enum Action {
        case sections(IdentifiedActionOf<ChildSection>)
        case fetchObjects
        case fetchObjectsResult(Result<[Object], Error>)
    }
    
    enum CancellableId: Hashable {
        case objectFetch
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchObjects:
                return .run { send in
                    await send(
                        .fetchObjectsResult(
                            Result {
                                try await service.fetchObjects("")
                            }
                        )
                    )
                }
                .cancellable(id: CancellableId.objectFetch, cancelInFlight: true)
                
            case .fetchObjectsResult(.success(let objects)):
                let rows = objects.map {
                    return ChildRow.State(number: $0.number)
                }
                
                // Do some mapping
                state.sections = state.sections(rows: rows)
                return .none
                
            case .fetchObjectsResult(.failure):
                // error handling
                return .none
                
            case .sections:
                return .none
            }
        }
        .forEach(\.sections, action: \.sections) {
            ChildSection()
        }
    }
}

struct ParentView: View {
    
    var store: StoreOf<Parent>
    
    init(store: StoreOf<Parent>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            List {
                ForEach(
                    store.scope(state: \.sections, action: \.sections)
                ) { childStore in
                    WithPerceptionTracking {
                        ChildSectionView(store: childStore)
                    }
                }
            }
            .onAppear {
                store.send(.fetchObjects)
            }
        }
    }
}
