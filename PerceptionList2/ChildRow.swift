//
//  ChildRow.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 21/2/2024.
//

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ChildRow {
    
    init() {}
    
    @ObservableState
    struct State: Identifiable {
        var id: UUID
        let number: Int
        
        init(id: UUID = UUID(), number: Int) {
            self.id = id
            self.number = number
        }
    }
    
    enum Action {
        case action
    }
}

struct ChildRowView: View {
    private let store: StoreOf<ChildRow>
    
    init(store: StoreOf<ChildRow>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            Text("\(store.number)")
        }
    }
}

extension Array where Element == ChildRow.State {
    // In the real app, this does some complex calculation of dates and times to group object together by date
    func group() -> [ChildSection.State] {
        let sectionDict = Dictionary(grouping: self, by: \.number)
        
        return sectionDict.keys.compactMap { key -> ChildSection.State? in
            guard let rows = sectionDict[key], let firstRow = rows.first else {
                return nil
            }
            return .init(
                title: "\(firstRow.number)",
                rows: IdentifiedArrayOf(uniqueElements: rows, id: \.id)
            )
        }
    }
}
