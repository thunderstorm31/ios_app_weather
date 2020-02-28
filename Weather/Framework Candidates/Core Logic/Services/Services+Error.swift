import Foundation

extension Services {
    public struct ServicesError: LocalizedError {
        public let reason: String
        public let possibleCauses: [String]
        public let suggestedFixes: [String]
        
        internal init(reason: String, possibleCauses: [String] = [], suggestedFixes: [String] = []) {
            self.reason = reason
            self.possibleCauses = possibleCauses
            self.suggestedFixes = suggestedFixes
        }
        
        public var description: String {
            let causes = possibleCauses.map { " - \($0)" }
            let fixes = suggestedFixes.map { " - \($0)" }
            
            var items: [String] = [reason]
            
            if causes.isEmpty == false {
                items.append("Possible causes:")
                
                items += causes
            }
            
            if fixes.isEmpty == false {
                items.append("Suggested fixes:")
                
                items += fixes
            }
            
            return items.joined(separator: "\n")
        }
    }
}
