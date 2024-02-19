//
//  ViewController.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 19/2/2024.
//

import ComposableArchitecture
import SwiftUI
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let parentStore = StoreOf<Parent>(
            initialState: Parent.State(
                children: [
                    Child.State(title: "Title 1"),
                    Child.State(title: "Title 2")
                ]
            ),
            reducer: { Parent() }
        )
        let view = ParentView(store: parentStore)

        let hostingController = UIHostingController(rootView: view)
        navigationController?.present(hostingController, animated: true)
    }
}



@Reducer
public struct Parent {
    
    public init() {}
    
    @ObservableState
    public struct State {
        var children: IdentifiedArrayOf<Child.State>
        
        public init(children: IdentifiedArrayOf<Child.State>) {
            self.children = children
        }
    }
    
    public enum Action {
        case children(IdentifiedActionOf<Child>)
    }
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
            .forEach(\.children, action: \.children) {
                Child()
            }
    }
}

public struct ParentView: View {
    
    var store: StoreOf<Parent>
    
    public init(store: StoreOf<Parent>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            List {
                ForEach(
                    store.scope(state: \.children, action: \.children)
                ) { childStore in
                    WithPerceptionTracking {
                        ChildView(store: childStore)
                    }
                }
            }
        }
    }
}

@Reducer
public struct Child {
    
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
    private let store: StoreOf<Child>
    
    public init(store: StoreOf<Child>) {
        self.store = store
    }
    
    public var body: some View {
        WithPerceptionTracking {
            Text(store.title)
        }
    }
}
