import Foundation

internal protocol CellLifecycle {
    func cellWillDisplay(at indexPath: IndexPath)
    func cellDidEndDisplaying(from indexPath: IndexPath)
}

extension CellLifecycle {
    internal func cellWillDisplay(at indexPath: IndexPath) {}
    internal func cellDidEndDisplaying(from indexPath: IndexPath) {}
}
