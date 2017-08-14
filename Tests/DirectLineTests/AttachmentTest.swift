import XCTest
import DirectLine

class AttachmentTest: XCTestCase {
	func testDecodeMediaAttachment() {
		// given
		let json = """
		{
			"contentType": "image/jpg",
			"contentUrl": "http://example.com/fistro.jpg",
			"name": "fistro.jpg"
		}
		""".data(using: .utf8)!
		let decoder = JSONDecoder()

		// when
		let attachment = try? decoder.decode(Attachment.self, from: json)

		// then
		XCTAssertTrue(attachment?.isMedia ?? false)
	}

	func testEncodeMediaAttachment() {
		// given
		let attachment = Attachment(
			content: .media(Media(contentType: .imageJPG, contentURL: URL(string: "http://example.com/fistro.jpg")!)),
			name: "fistro.jpg"
		)
		let expected = """
		{
		  "contentType" : "image\\/jpg",
		  "contentUrl" : "http:\\/\\/example.com\\/fistro.jpg",
		  "name" : "fistro.jpg"
		}
		""".data(using: .utf8)!
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		// when
		let result = (try? encoder.encode(attachment)) ?? Data()

		// then
		XCTAssertEqual(expected, result)
	}

	func testDecodeAdaptiveCardAttachment() {
		// given
		let json = """
		{
			"contentType": "application/vnd.microsoft.card.adaptive",
			"content": {}
		}
		""".data(using: .utf8)!
		let decoder = JSONDecoder()

		// when
		let attachment = try? decoder.decode(Attachment.self, from: json)

		// then
		XCTAssertTrue(attachment?.isAdaptiveCard ?? false)
	}

	func testDecodeAnimationCardAttachment() {
		// given
		let json = """
		{
			"contentType": "application/vnd.microsoft.card.animation",
			"content": {
				"media": [
					{
						"url": "http://i.giphy.com/Ki55RUbOV5njy.gif"
					}
				]
			}
		}
		""".data(using: .utf8)!
		let decoder = JSONDecoder()

		// when
		let attachment = try? decoder.decode(Attachment.self, from: json)

		// then
		XCTAssertTrue(attachment?.isAnimationCard ?? false)
	}

	func testDecodeAudioCardAttachment() {
		// given
		let json = """
		{
			"contentType": "application/vnd.microsoft.card.audio",
			"content": {
				"title": "I am your father",
				"subtitle": "Star Wars: Episode V - The Empire Strikes Back",
				"image": {
					"url": "https://upload.wikimedia.org/wikipedia/en/3/3c/SW_-_Empire_Strikes_Back.jpg"
				},
				"media": [
					{
						"url": "http://i.giphy.com/Ki55RUbOV5njy.gif"
					}
				],
				"buttons": [
					{
						"title": "Read More",
						"type": "openUrl",
						"value": "https://en.wikipedia.org/wiki/The_Empire_Strikes_Back"
					}
				]
			}
		}
		""".data(using: .utf8)!
		let decoder = JSONDecoder()

		// when
		let attachment = try? decoder.decode(Attachment.self, from: json)

		// then
		XCTAssertTrue(attachment?.isAudioCard ?? false)
	}

	func testDecodeUnknownAttachment() {
		// given
		let json = """
		{
			"contentType": "application/unknown",
			"content": {
				"foo": "bar"
			}
		}
		""".data(using: .utf8)!
		let decoder = JSONDecoder()

		// when
		let attachment = try? decoder.decode(Attachment.self, from: json)

		// then
		XCTAssertTrue(attachment?.isUnknown ?? false)
	}
}

private extension Attachment {
	var isMedia: Bool {
		switch content {
		case .media:
			return true
		default:
			return false
		}
	}

	var isAdaptiveCard: Bool {
		switch content {
		case .adaptiveCard:
			return true
		default:
			return false
		}
	}

	var isAnimationCard: Bool {
		switch content {
		case .animationCard:
			return true
		default:
			return false
		}
	}

	var isAudioCard: Bool {
		switch content {
		case .audioCard:
			return true
		default:
			return false
		}
	}

	var isUnknown: Bool {
		switch content {
		case .unknown:
			return true
		default:
			return false
		}
	}
}
