protocol XMLDecodable {
    static func decode(from element: Element) throws -> Self
}
