public struct CorrectResponse: XMLDecodable {
    public let values: [String]

    public static func decode(from element: Element) throws -> CorrectResponse {
        let values = try element.select("value")
        return try CorrectResponse(values: values.map { try $0.text() })
    }
}
