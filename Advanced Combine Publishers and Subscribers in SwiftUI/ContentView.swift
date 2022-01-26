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
    //    let currentValuePublisher = CurrentValueSubject<Int?, Error>()
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)) {
                self.passThroughPublisher.send(items[x])
                
                if (x > 4 && x < 8) {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }

                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.passThroughPublisher.send(1)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
    }
}

//final class TestVC: UIViewController {
//    let viewModel: AdvancedViewModel!
//
//    var viewModelSubsc: AnyCancellable?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewModelSubsc = viewModel.objectWillChange
//            .sink {
//
//        }
//    }
//
//    func render(viewModel: AdvancedViewModel) {
//
//    }
//}

class AdvancedViewModel: ObservableObject {
    
    @Published var data: [String] = []
    @Published var dataBools: [Bool] = []
    @Published var error: String = ""
    
    @Published var string: String = "" {
        didSet {
            self.objectWillChange.send()
        }
    }
    let dataService = AdvancedDataService()
    
    var cancellables = Set<AnyCancellable>()
    let multiCastPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        //        let a: Future <Void, Never>  = Future() { promise in
        //                DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
        //                    promise(Result.success(()))
        //                }
        //        }
        //            .eraseToAnyPublisher()
        
        //        let b = a
        //
        //        b.eraseToAnyPublisher()
        
        //        let _b = AnyPublisher<Void, Never>(a)
        //
        
        
        //        let v: Publisher = a
        //
        
        //        let publisher = Publishers.Breakpoint
        
        let subscriber = Subscribers.Sink<String, Never> { completion in
            print("")
        } receiveValue: { [weak self] returnedValue in
            self?.data.append(returnedValue)
        }
        
        cancellables.insert(.init(subscriber))
        
        
//        dataService.passThroughPublisher
        
        
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
        /*
        //            .map( {String($0) })
//                    .tryMap({ int in
//                        if int == 5 {
//                            throw URLError(.badServerResponse)
//                        }
//                        return int
//                    })
        //            .compactMap({ int in
        //                if int == 5 {
        //                    throw URLError(.badServerResponse)
        //                }
        //                return "\(int)"
        //            })
        //            .tryCompactMap()
//            .filter({ ($0 > 3) && ($0 < 7) })
//            .tryFilter({ int1 in
//                return int1 > 5
//            })
//            .removeDuplicates()
//            .removeDuplicates(by: { int1, int2 in
//                int1 == int2
//            })
//            .tryRemoveDuplicates(by: { int1, int2 in
//                int1 == int2
//            })
//            .replaceNil(with: 5)
//            .replaceEmpty(with: [])
//            .replaceError(with: "Default value")
//            .scan(0, { existingValue, newValue in
//                return existingValue + newValue
//            })
//            .scan(0, { $0 + $1 })
//            .scan(0, +)
//            .tryScan(0, { firstInt, secondInt in
//                return firstInt + secondInt
//            })
//            .reduce(0, { existingValue, newValue in
//                existingValue + newValue
//            })
//            .reduce(0, +)
//            .collect()
//            .collect(3)
//            .allSatisfy({ $0 == 5 })
//            .tryAllSatisfy({ int in
//                if int == 11 {
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
        */
        
        // Timing Operations
        /*
//            .debounce(for: 0.75, scheduler: DispatchQueue.main)
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .measureInterval(using: DispatchQueue.main)
//            .map({ stride in
//                return "\(stride.timeInterval)"
//            })
//            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
//            .retry(3)
//            .timeout(0.75, scheduler: DispatchQueue.main)
        */
        
        // Multiple Publishers/Subscribers
        /*
//            .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//            .compactMap({ (int, bool) in
//                if bool {
//                    return String(int)
//                }
//                return nil
//            })
//            .compactMap({ $1 ? String($0) : nil})
//            .compactMap({ (int1, bool, int2) in
//                if bool {
//                    return String(int1)
//                }
//                return "n/a"
//            })
//            .merge(with: dataService.intPublisher)
//            .zip(dataService.boolPublisher, dataService.intPublisher)
//            .map({ tuple in
//                return String(tuple.0) + tuple.1.description + String(tuple.2)
//            })
        
//            .tryMap({ int in
//
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataService.intPublisher
//            })
        */
        
        let sharedPublisher = dataService.passThroughPublisher
//            .dropFirst(3)
            .share()
//            .multicast {
//                PassthroughSubject<Int, Error>()
//            }
            .multicast(subject: multiCastPublisher)
        
        sharedPublisher
            .catch { error -> Just<Int> in
                self.error = "ERROR: \(error)"
                return Just(0)
            }
        
        
            .map({ String($0 )})

        //            .assign(to: &cancellables)
        //            .subscribe(subscriber)
        //            .receive(subscriber: subscriber)
            .sink { [weak self] returnedValue in
//                self?.data.append(contentsOf: returnedValue)
                self?.data.append(returnedValue)
            }
        
        
        //        Subscribers.Sink(receiveCompletion: <#T##((Subscribers.Completion<_>) -> Void)##((Subscribers.Completion<_>) -> Void)##(Subscribers.Completion<_>) -> Void#>, receiveValue: <#T##((_) -> Void)##((_) -> Void)##(_) -> Void#>)
        //            .sink { completion in
        //                switch completion {
        //                case .finished:
        //                    break
        //                case .failure(let error):
        //                    self.error = "ERROR: \(error)"
        //                }
        //            } receiveValue: { [weak self] returnedValue in
        ////                guard let self = self else { return }
        //
        //                self?.data.append(returnedValue)
        //            }
            .store(in: &cancellables)
        
        
        sharedPublisher
            .catch { error -> Just<Int> in
                self.error = "ERROR: \(error)"
                return Just(0)
            }
            .map({ $0 > 5 ? true : false })
            .sink { [weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            sharedPublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
    
}

struct ContentView: View {
    
    @StateObject private var vm = AdvancedViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
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
                VStack {
                    ForEach(vm.dataBools, id: \.self) {
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
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
