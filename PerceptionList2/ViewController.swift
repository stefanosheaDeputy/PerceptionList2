//
//  ViewController.swift
//  PerceptionList2
//
//  Created by Stefan O'Shea on 19/2/2024.
//

import ComposableArchitecture
import Perception
import SwiftUI
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let parentStore = StoreOf<Parent>(
            initialState: Parent.State(),
            reducer: {
                Parent()
                    .dependency(\.service, .init(client: SomeNetworkClient()))
            }
        )
        let view = ParentView(store: parentStore)

        let hostingController = UIHostingController(rootView: view)
        navigationController?.present(hostingController, animated: true)
    }
}
