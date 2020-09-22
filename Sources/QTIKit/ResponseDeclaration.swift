public struct ResponseDeclaration: XMLDecodable, Identifiable {

    public let id: String
    public let correctResponse: CorrectResponse

    public static func decode(from element: Element) throws -> ResponseDeclaration {
        guard let correctResponse = try element.select("correctResponse").first() else { throw ParseError.missingTag("correctResponse") }
        return try ResponseDeclaration(
            id: element.attr("identifier"),
            correctResponse: .decode(from: correctResponse)
        )
    }
}
