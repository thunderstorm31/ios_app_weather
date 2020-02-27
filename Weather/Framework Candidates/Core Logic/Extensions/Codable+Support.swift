import Foundation

/**
 This protocol is used to generalize PropertyListEncoder, JSONEncoder and any other custom encoder. The default classes do not conform to any protocol.
 */
public protocol EncoderType {
    func encode<Value>(_ value: Value) throws -> Data where Value: Encodable
}

/**
 This protocol is used to generalize PropertyListDecoder, JSONDecoder and any other custom decoder. The default classes do not conform to any protocol.
 */
public protocol DecoderType {
    var userInfo: [CodingUserInfoKey: Any] { get set }

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension PropertyListEncoder: EncoderType { }
extension JSONEncoder: EncoderType { }

extension PropertyListDecoder: DecoderType { }
extension JSONDecoder: DecoderType { }

/**
 A limitation of the current implementations of JSON(De/En)coder and PropertyList(De/En)coder is that they cannot encode or decode primitive root types while they do
 accept them as a valid argument because they do conform to the Codable protocol.

 To detect a primitive root type this function tests the type with all Codable primmitive types.
 */
private func isPrimitiveRootType(_ type: Any.Type) -> Bool {
    return type is Int.Type || type is Int8.Type || type is Int16.Type || type is Int32.Type || type is Int64.Type
        || type is UInt.Type || type is UInt8.Type || type is UInt16.Type || type is UInt32.Type || type is UInt64.Type
        || type is Float.Type || type is Double.Type
        || type is String.Type || type is Bool.Type
        || type is Date.Type 
}

extension Encodable {
    /**
     Encodes the encodable type. By default a PropertyListEncoder is used but the optional encoder parameter can accept any encoder instance.

     Note: also allows encoding of primitive root types. In that case the value will be wrapped in a dictionary.

     - parameter encoder: optional customized encoder.

     - returns: the encoded data or nil if it could not be encoded.
     */
    public func encode(encoder: EncoderType = PropertyListEncoder()) -> Data? {
        do {
            if isPrimitiveRootType(type(of: self)) {
                return try encodePrimitiveType(encoder: encoder)
            } else {
                return try encoder.encode(self)
            }
        } catch {
            assertionFailure("Failed to encode: " + error.localizedDescription)

            return nil
        }
    }

    private func encodePrimitiveType(encoder: EncoderType) throws -> Data? {
        return try encoder.encode(["v": self])
    }
}

extension Data {
    /**
     Decodes the data back the decodable type. By default a PropertyListDecoder is used but the optional decoder parameter can accept any decoder instance.

     Note: also allows decoding of primitive root types. In that case the value is expected to be wrapped in a dictionary with the key "v".

     - parameter type: The type to decode.
     - parameter decoder: optional customized decoder.

     - returns: the decoded type or nil if the data could not be decoded.
     */
    public func decode<T: Decodable>(type: T.Type, decoder: DecoderType = PropertyListDecoder()) -> T? {
        do {
            if isPrimitiveRootType(type) {
                return try decodePrimitiveType(type: type, decoder: decoder)
            } else {
                return try decoder.decode(type, from: self)
            }
        } catch {
            return nil
        }
    }

    private func decodePrimitiveType<T: Decodable>(type: T.Type, decoder: DecoderType) throws -> T? {
        return (try decoder.decode([String: T].self, from: self))["v"]
    }
}
