//
//  Store.swift
//  Dividend App
//
//  Created by Kevin Li on 12/23/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

// Credits: https://github.com/mecid/swiftui-recipes-app/blob/master/Recipes/Shared/Model/Store.swift

import SwiftUI
import Combine

typealias Reducer<State, Action> = (inout State, Action) -> Void

final class Store<State, Action>: ObservableObject {
    typealias Effect = AnyPublisher<Action, Never>

    @Published private(set) var state: State

    private let reducer: Reducer<State, Action>
    private var cancellables: Set<AnyCancellable> = []

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        reducer(&state, action)
    }

    func send(_ effect: Effect) {
        var cancellable: AnyCancellable?
        var didComplete = false

        cancellable = effect
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    didComplete = true
                    if let effectCancellable = cancellable {
                        self?.cancellables.remove(effectCancellable)
                    }
                }, receiveValue: send)

        if !didComplete, let effectCancellable = cancellable {
            cancellables.insert(effectCancellable)
        }
    }
}

extension Store {
    func binding<Value>(
        for keyPath: KeyPath<State, Value>,
        _ action: @escaping (Value) -> Action
    ) -> Binding<Value> {
        Binding<Value>(
            get: { self.state[keyPath: keyPath] },
            set: { self.send(action($0)) }
        )
    }
}

extension Store where State: Codable {
    func save() {
        DispatchQueue.global(qos: .utility).async {
            guard
                let documentsURL = Current.files.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
                let data = try? Current.encoder.encode(self.state)
                else { return }
            
            try? Current.files.createDirectory(
                at: documentsURL,
                withIntermediateDirectories: true,
                attributes: nil
            )

            let stateURL = documentsURL.appendingPathComponent("state.json")
            
            if Current.files.fileExists(atPath: stateURL.absoluteString) {
                try? Current.files.removeItem(at: stateURL)
            }

            try? data.write(to: stateURL, options: .atomic)
        }
    }

    func load() {
        DispatchQueue.global(qos: .utility).async {
            guard
                let documentsURL = Current.files.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
                let data = try? Data(contentsOf: documentsURL.appendingPathComponent("state.json")),
                let state = try? Current.decoder.decode(State.self, from: data)
                else { return }

            DispatchQueue.main.async {
                self.state = state
            }
        }
    }
}

