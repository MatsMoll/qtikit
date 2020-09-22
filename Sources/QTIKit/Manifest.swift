import Foundation

public struct Manifest: XMLDecodable {

    public let metadata: Metadata
    public let resources: [Resource]

    public struct Metadata: XMLDecodable {

        public let schemaVersion: Double

        public static func decode(from element: Element) throws -> Manifest.Metadata {

            guard let schemaVersionText = try element.select("schemaversion").first()?.text() else { throw ParseError.missingTag("schemaversion") }
            guard let schemaVersion = Double(schemaVersionText) else { throw ParseError.invalidDouble(value: schemaVersionText) }
            return Metadata(schemaVersion: schemaVersion)
        }
    }

    static func decode(from element: Element) throws -> Manifest {
        guard let metadata = try element.select("metadata").first() else { throw ParseError.missingTag("metadata") }
        return try Manifest(
            metadata: Metadata.decode(from: metadata),
            resources: element.select("resources > resource").map(Resource.decode(from:))
        )
    }

    public func assessmentItems() throws -> [AssessmentItem] {
        guard let path = QTIKit.shared.path else { throw ParseError.invalidPath("Missing") }
        let url = URL(fileURLWithPath: path)
        return try resources.filter({ $0.type.contains("qti_item_xml") })
            .map { resource in
                let resourceURL = url.deletingLastPathComponent().appendingPathComponent(resource.file)
                let xml = try String(contentsOf: resourceURL)
                let document = try SwiftSoup.parseBodyFragment(xml)
                guard let item = try document.select("assessmentItem").first() else { throw ParseError.missingTag("assessmentItem") }
                return try AssessmentItem.decode(from: item)
        }
    }

    public func assessmentTest() throws -> [AssessmentTest] {
        guard let path = QTIKit.shared.path else { throw ParseError.invalidPath("Missing") }
        let url = URL(fileURLWithPath: path)
        return try resources.filter({ $0.type.contains("qti_test_xml") })
            .map { resource in
                let resourceURL = url.deletingLastPathComponent().appendingPathComponent(resource.file)
                let xml = try String(contentsOf: resourceURL)
                let document = try SwiftSoup.parseBodyFragment(xml)
                guard let item = try document.select("assessmentTest").first() else { throw ParseError.missingTag("assessmentTest") }
                return try AssessmentTest.decode(from: item)
        }
    }
}

public struct Resource: Identifiable, XMLDecodable {

    struct Dependency: XMLDecodable {
        let idRef: String

        static func decode(from element: Element) throws -> Resource.Dependency {
            try Dependency(idRef: element.attr("identifierref"))
        }
    }

    public let id: String
    public let type: String

    let file: String
    let dependencies: [Dependency]

    public static func decode(from element: Element) throws -> Resource {
        guard let file = try element.select("file").first() else { throw ParseError.missingTag("file") }
        return try Resource(
            id: element.attr("identifier"),
            type: element.attr("type"),
            file: file.attr("href"),
            dependencies: element.select("dependency").map(Dependency.decode(from:))
        )
    }
}
