import Foundation

public struct AssessmentItem: Identifiable, XMLDecodable {

    struct Reference: Identifiable, XMLDecodable {

        let id: String
        let href: URL

        static func decode(from element: Element) throws -> AssessmentItem.Reference {
            let href = try element.attr("href")
            guard let url = URL(string: href) else { throw ParseError.misformed(attribute: "href", value: href) }
            return try AssessmentItem.Reference(
                id: element.attr("identifier"),
                href: url
            )
        }
    }

    public let id: String
    public let response: ResponseDeclaration
    public let itemBody: ItemBody

    static func decode(from element: Element) throws -> AssessmentItem {
        let id = try element.attr("identifier")
        guard let responseElement = try element.select("responseDeclaration").first() else { throw ParseError.missingTag("responseDeclaration") }
        guard let itemBodyElement = try element.select("itemBody").first() else { throw ParseError.missingTag("itemBody") }

        let response = try ResponseDeclaration.decode(from: responseElement)
        let itemBody = try ItemBody.decode(from: itemBodyElement)
        return AssessmentItem(id: id, response: response, itemBody: itemBody)
    }

    static func decode(from referance: Reference) throws -> AssessmentItem {
        var resourceURL: URL?
        if let sharedPath = QTIKit.pathForResource(id: referance.id) {
            resourceURL = URL(fileURLWithPath: sharedPath)
        } else if let sharedPath = QTIKit.shared.path {
            let url = URL(fileURLWithPath: sharedPath)
            var dir = url.deletingLastPathComponent()
            dir.appendPathComponent(referance.href.path)
            resourceURL = dir
        }
        guard let url = resourceURL else { throw ParseError.invalidPath(referance.href.path) }
        let xml = try String(contentsOf: url)
        let document = try SwiftSoup.parseBodyFragment(xml)
        guard let item = try document.select("assessmentItem").first() else { throw ParseError.missingTag("assessmentItem") }
        return try decode(from: item)
    }
}
