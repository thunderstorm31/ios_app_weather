import Foundation

public final class DispatchTools: NSObject {
    /// Queues the execution of provided block on the main queue.
    ///
    /// - parameter block: The block to run.
    public static func onMain(block: @escaping (() -> Void)) {
        DispatchQueue.main.async(execute: block)
    }

    /// Queues the execution of provided block on the main queue with provided delay.
    ///
    /// - parameter delay: The delay in seconds.
    /// - parameter block: The block to run.
    public static func onMain(withDelay delay: TimeInterval, block: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: block)
    }

    /// Queues the execution of provided block on an arbitrary background thread.
    ///
    /// - parameter block: The block to run.
    public static func onBackground(block: @escaping (() -> Void)) {
        DispatchQueue.global().async(execute: block)
    }

    /// Queues the execution of provided block on an arbitrary background thread.
    ///
    /// - parameter delay: The delay in seconds.
    /// - parameter block: The block to run.
    public static func onBackground(withDelay delay: TimeInterval, block: @escaping (() -> Void)) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: block)
    }
}
