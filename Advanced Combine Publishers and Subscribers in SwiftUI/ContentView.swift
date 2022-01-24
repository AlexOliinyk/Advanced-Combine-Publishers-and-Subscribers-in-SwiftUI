//
//  ContentView.swift
//  Advanced Combine Publishers and Subscribers in SwiftUI
//
//  Created by Oleksandr Oliinyk on 24.01.2022.
//

import SwiftUI
import Combine

class AdvancedDataService {
    
//    @Published var basicPablisher: String = "first publish"
//    let currentValuePublisher = CurrentValueSubject<Int, Error>()
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
                self.passThroughPublisher.send(items[x])
                
                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
    }
}

class AdvancedViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var error: String = ""
    let dataService = AdvancedDataService()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.passThroughPublisher
        
        
            // Sequence Operations
        /*
//            .first()
//            .first(where: { int in
//                return int > 4
//            })
//            .first(where: { $0 > 4})
//            .tryFirst(where: { int in
//                if int == 3 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1
//            })
//            .last()
//            .last(where: { $0 < 4})
//            .tryLast(where: { int in
//                if int == 11 {
//                    throw URLError(.badServerResponse)
//                }
//                return int > 1
//            })
//            .dropFirst()
//            .dropFirst(3)
//            .drop(while: { $0 < 5})
//            .tryDrop(while: { int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 4
//            })
//            .prefix(4)
//            .prefix(while: { $0 < 5 })
//            .tryPrefix(while: { int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int < 6
//            })
//            .output(at: 6)
//            .output(in: 2..<4)
         */
        
            // Math Operations
        /*
//            .max()
//            .max(by: { int1, int2 in
//                return int1 < int2
//            })
//            .tryMax(by: { int1, int2 in
//                return int1 < int2
//            })
//            .min()
//            .min(by: )
//            .tryMin(by: )
        */
        
            // Filter / Reducing Operations
//            .map( {String($0) })
//            .tryMap({ int -> String in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return String(int)
//            })
//            .compactMap({ int in
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return "\(int)"
//            })
//            .tryCompactMap()
        
            .map( {String($0) })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = "ERROR: \(error)"
                }
            } receiveValue: { [weak self] returnedValue in
                guard let self = self else { return }
                
                self.data.append(returnedValue)
            }
            .store(in: &cancellables)

    }
    
}

struct ContentView: View {
    
    @StateObject private var vm = AdvancedViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                if !vm.error.isEmpty {
                    Text(vm.error)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
