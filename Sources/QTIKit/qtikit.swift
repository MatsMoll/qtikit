import SwiftSoup
import Foundation

enum ParseError: Error {
    case missingAttribute(String)
    case missingTag(String)
    case misformed(attribute: String, value: String)
    case invalidPath(String)
    case invalidXML
    case invalidDouble(value: String)
    case unableToRead(file: String)
}

public class QTIKit {

    var path: String?
    var manifest: Manifest?
    var fileManager: FileManager = FileManager.default

    static let shared = QTIKit()

    public static func assessmentItem(path: String) throws -> AssessmentItem {

        guard shared.fileManager.fileExists(atPath: path) else { throw ParseError.invalidPath(path) }
        guard let data = shared.fileManager.contents(atPath: path) else { throw ParseError.unableToRead(file: path) }
        guard let xml = String(data: data, encoding: .utf8) else { throw ParseError.invalidXML }

        shared.path = path
        return try assessmentItem(withXML: xml)
    }

    public static func assessmentItem(withXML xml: String) throws -> AssessmentItem {
        let document = try SwiftSoup.parseBodyFragment(xml)

        guard let assessment = try? document.select("assessmentItem").first() else { throw ParseError.missingTag("assessmentItem") }
        return try AssessmentItem.decode(from: assessment)
    }

    public static func assessmentTest(path: String) throws -> AssessmentTest {

        guard shared.fileManager.fileExists(atPath: path) else { throw ParseError.invalidPath(path) }
        guard let data = shared.fileManager.contents(atPath: path) else { throw ParseError.unableToRead(file: path) }
        guard let xml = String(data: data, encoding: .utf8) else { throw ParseError.invalidXML }

        shared.path = path
        return try assessmentTest(withXML: xml)
    }

    public static func assessmentTest(withXML xml: String) throws -> AssessmentTest {
        let document = try SwiftSoup.parseBodyFragment(xml)

        guard let assessment = try? document.select("assessmentTest").first() else { throw ParseError.missingTag("assessmentTest") }
        return try AssessmentTest.decode(from: assessment)
    }

    public static func manifest(atPath path: String) throws -> Manifest {

        guard shared.fileManager.fileExists(atPath: path) else { throw ParseError.invalidPath(path) }
        guard let data = shared.fileManager.contents(atPath: path) else { throw ParseError.unableToRead(file: path) }
        guard let xml = String(data: data, encoding: .utf8) else { throw ParseError.invalidXML }
        shared.path = path
        return try manifest(withXML: xml)
    }

    public static func manifest(withXML xml: String) throws -> Manifest {
        let document = try SwiftSoup.parseBodyFragment(xml)

        guard let assessment = try? document.select("manifest").first() else { throw ParseError.missingTag("manifest") }
        let manifest = try Manifest.decode(from: assessment)
        shared.manifest = manifest
        return manifest
    }

    static func pathForResource(id: String) -> String? {
        guard
            let path = shared.path,
            let resourcePath = shared.manifest?.resources.first(where: { $0.id == id })?.file
        else { return nil }
        return URL(fileURLWithPath: path).deletingLastPathComponent().appendingPathComponent(resourcePath).path
    }
}
