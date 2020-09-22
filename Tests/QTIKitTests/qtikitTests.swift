import XCTest
@testable import QTIKit

final class qtikitTests: XCTestCase {

    func assessmentTestPath() -> String {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent("QuestionPool/qti21/question_bank00001.xml")
        return url.path
    }

    func assessmentItemPath() -> String {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent("QuestionPool/qti21/assessmentItem00002.xml")
        return url.path
    }

    func manifestPath() -> String {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let url = thisDirectory.appendingPathComponent("QuestionPool/imsmanifest.xml")
        return url.path
    }

    func testAssessmentItem() throws {
        _ = try QTIKit.assessmentItem(path: assessmentItemPath())
    }

    func testAssessmentTest() throws {
        _ = try QTIKit.assessmentTest(path: assessmentTestPath())
    }

    func testManifiest() throws {
        let manifest = try QTIKit.manifest(atPath: manifestPath())
        try XCTAssertTrue(manifest.assessmentItems().count > 10)
        try XCTAssertEqual(manifest.assessmentTest().count, 1)
    }
}
