import Foundation

internal final class SearchAccelerator<T> {
    internal typealias PerformSearchClosure = (() -> T)
    internal typealias SearchCompletedClosure = ((_ results: T) -> Void)

    private final class SearchOperation<T>: Operation {
        private let searchClosure: PerformSearchClosure
        private let completedClosure: SearchCompletedClosure

        fileprivate init(searchClosure: @escaping PerformSearchClosure, completedClosure: @escaping SearchCompletedClosure) {
            self.searchClosure = searchClosure
            self.completedClosure = completedClosure
        }

        fileprivate override func main() {
            guard isCancelled == false else {
                return
            }

            let results = searchClosure()

            guard isCancelled == false else {
                return
            }

            DispatchTools.onMain {
                self.completedClosure(results)
            }
        }
    }

    private let operationQueue = OperationQueue()

    internal init() {
        operationQueue.qualityOfService = .userInitiated
        operationQueue.maxConcurrentOperationCount = min(1, ProcessInfo.processInfo.activeProcessorCount - 1)
    }

    internal func perform(searchClosure: @escaping PerformSearchClosure, completed: @escaping SearchCompletedClosure) {
        operationQueue.operations.forEach {
            $0.cancel()
        }

        operationQueue.addOperation(SearchOperation<T>(searchClosure: searchClosure, completedClosure: completed))
    }
}
