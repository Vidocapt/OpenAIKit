//
//  OpenAIKitTests.swift
//  OpenAIKit
//
//  Copyright (c) 2023 OpenDive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import XCTest
@testable import OpenAIKit

final class OpenAIKitTests: XCTestCase {
    func testThatVerifiesOpenAIIsAbleToFetchAListOfModels() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            // When
            let modelsResponse = try await mockOpenAI.listModels()

            // Then
            XCTAssertEqual(
                modelsResponse.object,
                .list,
                "Model Response is not a list object."
            )
            XCTAssertFalse(
                modelsResponse.data.isEmpty,
                "Model Response data is empty."
            )
            XCTAssertEqual(
                modelsResponse.data[0].id,
                "model-id-0",
                "Model Response doesn't contain the named model."
            )
            XCTAssertEqual(
                modelsResponse.data[0].object,
                .model,
                "Model type isn't a model."
            )
            XCTAssertEqual(
                modelsResponse.data[0].created,
                1686935002,
                "Model doesn't contain correct creation date."
            )
            XCTAssertEqual(
                modelsResponse.data[0].ownedBy,
                "organization-owner",
                "Model doesn't have correct owner."
            )
        } catch {
            XCTFail("LIST MODELS TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToRetrieveModelUsingID() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            // When
            let model = try await mockOpenAI.retrieveModel(
                modelId: "davinci"
            )

            // Then
            XCTAssertEqual(
                model.id,
                "davinci",
                "Model Response doesn't contain the Davinvi model."
            )
            XCTAssertEqual(
                model.object,
                .model,
                "Model type isn't a model."
            )
            XCTAssertEqual(
                model.created,
                1686935002,
                "Model doesn't contain correct creation date."
            )
            XCTAssertEqual(
                model.ownedBy,
                "openai",
                "Model doesn't have correct owner."
            )
        } catch {
            XCTFail("RETRIEVE MODEL TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToCompleteTextPrompts() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let completionParameter = CompletionParameters(model: .davinci)

            // When
            let completionResponse = try await mockOpenAI.generateCompletion(
                parameters: completionParameter
            )

            // Then
            XCTAssertEqual(
                completionResponse.id,
                "cmpl-69nq0IKF1lwssd3QdLnz4fQ4yCt4O",
                "Completion Response has incorrect ID."
            )
            XCTAssertEqual(
                completionResponse.object,
                .textCompletion,
                "Completion Response has incorrect object type."
            )
            XCTAssertEqual(
                completionResponse.created,
                1667794548,
                "Completion Response has incorrect creation date."
            )
            XCTAssertEqual(
                completionResponse.model,
                "text-davinci-002",
                "Completion Response has incorrect model."
            )
            XCTAssertTrue(
                completionResponse.choices[0].text.contains("This is a test"),
                "Completion Response has incorrect completion."
            )
            XCTAssertEqual(
                completionResponse.choices[0].index,
                0,
                "Completion Response has incorrect index."
            )
            XCTAssertNil(
                completionResponse.choices[0].logprobs,
                "Completion Response shouldn't have logprobs."
            )
            XCTAssertEqual(
                completionResponse.choices[0].finishReason!,
                "length",
                "Completion Response has incorrect finish reason."
            )
            XCTAssertEqual(
                completionResponse.usage.promptTokens,
                5,
                "Completion Response has incorrect prompt token usage."
            )
            XCTAssertEqual(
                completionResponse.usage.completionTokens,
                6,
                "Completion Response has incorrect completion token usage."
            )
            XCTAssertEqual(
                completionResponse.usage.totalTokens,
                11,
                "Completion Response has incorrect total token usage."
            )
        } catch {
            XCTFail("COMPLETION PROMPT TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToGenerateImagesUsingGivenPrompts() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let parameterApple = ImageParameters(
                prompt: "A red apple.",
                user: "promptApple"
            )
            let parameterOtter = ImageParameters(
                prompt: "A cute baby sea otter",
                user: "promptOtter"
            )

            // When
            let apple = try await mockOpenAI.createImage(
                parameters: parameterApple
            )
            let otter = try await mockOpenAI.createImage(
                parameters: parameterOtter
            )

            // Then
            XCTAssertEqual(
                apple.created,
                1667676516,
                "Created date of Apple is incorrect."
            )
            XCTAssertFalse(
                apple.data.isEmpty,
                "Contents of Apple is empty."
            )
            XCTAssertTrue(
                apple.data[0].image.contains("img-nsJnMAwG1wUsEx5kem6LWGvJ.png"),
                "Contents of Apple URL isn't valid."
            )

            XCTAssertEqual(
                otter.created,
                1667661280,
                "Created date of Otter is incorrect."
            )
            XCTAssertFalse(
                otter.data.isEmpty,
                "Contents of Otter is empty."
            )
            XCTAssertTrue(
                otter.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of Otter URL isn't valid."
            )
        } catch {
            XCTFail("PROMPT TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesEmptyPromptsThrowAnError() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            // When
            let parameterEmptyPrompt = ImageParameters(
                prompt: "",
                user: "promptEmpty"
            )

            // Then
            _ = try await mockOpenAI.createImage(
                parameters: parameterEmptyPrompt
            )
        } catch MockOpenAIError.invalidPrompt {
            XCTAssertTrue(true)
        } catch {
            XCTFail("EMPTY PROMPT TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToGenerateImagesGivenDifferentResponseTypes() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let parameterUrl = ImageParameters(
                prompt: "A cute baby sea otter",
                responseFormat: .url,
                user: "responseURL"
            )
            let parameterB64 = ImageParameters(
                prompt: "A cute baby sea otter",
                responseFormat: .base64Json,
                user: "responseB64"
            )

            // When
            let url = try await mockOpenAI.createImage(
                parameters: parameterUrl
            )
            let b64 = try await mockOpenAI.createImage(
                parameters: parameterB64
            )

            // Then
            XCTAssertEqual(
                url.created,
                1667661280,
                "Created date of url is incorrect."
            )
            XCTAssertFalse(
                url.data.isEmpty,
                "Contents of url is empty."
            )
            XCTAssertTrue(
                url.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of url URL isn't valid."
            )

            XCTAssertEqual(
                b64.created,
                1667615111,
                "Created date of b64 is incorrect."
            )
            XCTAssertFalse(
                b64.data.isEmpty,
                "Contents of b64 is empty."
            )
            XCTAssertTrue(
                b64.data[0].image.contains("CAQAAAf8C/wL9AAACAQEA////AAH+/gD+/wD+AAH+AAD+Af//A"),
                "Contents of b64 data isn't valid."
            )
        } catch {
            XCTFail("RESPONSE TYPE TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToGenerateDifferentResolutions() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let parameterSmallUrl = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .small,
                user: "sizeSmallURL"
            )
            let parameterSmallB64 = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .small,
                user: "sizeSmallB64"
            )

            let parameterMediumUrl = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .medium,
                user: "sizeMediumURL"
            )
            let parameterMediumB64 = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .medium,
                user: "sizeMediumB64"
            )

            let parameterLargeUrl = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .large,
                user: "sizeLargeURL"
            )
            let parameterLargeB64 = ImageParameters(
                prompt: "A cute baby sea otter",
                resolution: .large,
                user: "sizeLargeB64"
            )

            // When
            let smallUrl = try await mockOpenAI.createImage(
                parameters: parameterSmallUrl
            )
            let smallB64 = try await mockOpenAI.createImage(
                parameters: parameterSmallB64
            )

            let mediumUrl = try await mockOpenAI.createImage(
                parameters: parameterMediumUrl
            )
            let mediumB64 = try await mockOpenAI.createImage(
                parameters: parameterMediumB64
            )

            let largeUrl = try await mockOpenAI.createImage(
                parameters: parameterLargeUrl
            )
            let largeB64 = try await mockOpenAI.createImage(
                parameters: parameterLargeB64
            )

            // Then
            XCTAssertEqual(
                smallUrl.created,
                1667661280,
                "Created date of smallUrl is incorrect."
            )
            XCTAssertFalse(
                smallUrl.data.isEmpty,
                "Contents of smallUrl is empty."
            )
            XCTAssertTrue(
                smallUrl.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of smallUrl URL isn't valid."
            )

            XCTAssertEqual(
                smallB64.created,
                1667615111,
                "Created date of smallB64 is incorrect."
            )
            XCTAssertFalse(
                smallB64.data.isEmpty,
                "Contents of smallB64 is empty."
            )
            XCTAssertTrue(
                smallB64.data[0].image.contains("CAQAAAf8C/wL9AAACAQEA////AAH+/gD+/wD+AAH+AAD+Af//A"),
                "Contents of smallB64 data isn't valid."
            )

            XCTAssertEqual(
                mediumUrl.created,
                1667674510,
                "Created date of mediumUrl is incorrect."
            )
            XCTAssertFalse(
                mediumUrl.data.isEmpty,
                "Contents of mediumUrl is empty."
            )
            XCTAssertTrue(
                mediumUrl.data[0].image.contains("img-euW0HHRIAcFPddYSrH88KT5m.png"),
                "Contents of mediumUrl URL isn't valid."
            )

            XCTAssertEqual(
                mediumB64.created,
                1667674568,
                "Created date of mediumB64 is incorrect."
            )
            XCTAssertFalse(
                mediumB64.data.isEmpty,
                "Contents of mediumB64 is empty."
            )
            XCTAssertTrue(
                mediumB64.data[0].image.contains("+/v/7AP0CAwL+9/3x8vL3+PoFBQr+Afj8AgEB/wEFAAMAAwcIB"),
                "Contents of mediumB64 data isn't valid."
            )

            XCTAssertEqual(
                largeUrl.created,
                1667674848,
                "Created date of largeUrl is incorrect."
            )
            XCTAssertFalse(
                largeUrl.data.isEmpty,
                "Contents of largeUrl is empty."
            )
            XCTAssertTrue(
                largeUrl.data[0].image.contains("img-8cl5NT9LdOxfxtb50M3SoMtg.png"),
                "Contents of largeUrl URL isn't valid."
            )

            XCTAssertEqual(
                largeB64.created,
                1667674929, "Created date of smallB64 is incorrect."
            )
            XCTAssertFalse(
                largeB64.data.isEmpty,
                "Contents of smallB64 is empty."
            )
            XCTAssertTrue(
                largeB64.data[0].image.contains("+BAEDAf7+/vv//gYAAQAB/gID/v38AgAA/v/+Af8BBPwA/AIAA"),
                "Contents of smallB64 data isn't valid."
            )
        } catch {
            XCTFail("RESOLUTION TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToGenerateImageGivenDifferentImageAmountsAndDoesNotGoOverNorUnderLimits() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let image1Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: 1,
                user: "number1"
            )
            let image2Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: 2,
                user: "number2"
            )
            let image10Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: 10,
                user: "number10"
            )
            let image11Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: 11,
                user: "number11"
            )
            let image0Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: 0,
                user: "number0"
            )
            let imageNegative1Parameter = ImageParameters(
                prompt: "A cute baby sea otter",
                numberofImages: -1,
                user: "number-1"
            )

            // When
            let image1 = try await mockOpenAI.createImage(
                parameters: image1Parameter
            )
            let image2 = try await mockOpenAI.createImage(
                parameters: image2Parameter
            )
            let image10 = try await mockOpenAI.createImage(
                parameters: image10Parameter
            )
            let image11 = try await mockOpenAI.createImage(
                parameters: image11Parameter
            )
            let image0 = try await mockOpenAI.createImage(
                parameters: image0Parameter
            )
            let imageNegative1 = try await mockOpenAI.createImage(
                parameters: imageNegative1Parameter
            )

            // Then
            XCTAssertEqual(
                image1.created,
                1667661280,
                "Created date of image1 is incorrect."
            )
            XCTAssertFalse(
                image1.data.isEmpty,
                "Contents of image1 is empty."
            )
            XCTAssertTrue(
                image1.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of image1 URL isn't valid."
            )

            XCTAssertEqual(
                image2.created,
                1667676103,
                "Created date of image2 is incorrect."
            )
            XCTAssertFalse(
                image2.data.isEmpty,
                "Contents of image2 is empty."
            )

            image2.data.enumerated().forEach { (idx, response) in
                XCTAssertTrue(
                    response.image.contains("org-3JlqS7fDgniMfkzHfwwEdBm3/user-a1pfIvdAwqSA0RVdjzqH921M"),
                    "URL of image2 at index \(idx) isn't valid."
                )
            }

            XCTAssertEqual(
                image10.created,
                1667676139,
                "Created date of image10 is incorrect."
            )
            XCTAssertFalse(
                image10.data.isEmpty,
                "Contents of image10 is empty."
            )

            image10.data.enumerated().forEach { (idx, response) in
                XCTAssertTrue(
                    response.image.contains("org-3JlqS7fDgniMfkzHfwwEdBm3/user-a1pfIvdAwqSA0RVdjzqH921M"),
                    "URL of image10 at index \(idx) isn't valid."
                )
            }

            XCTAssertEqual(
                image11Parameter.numberOfImages,
                10,
                "Image11's parameters wasn't set correctly."
            )
            XCTAssertEqual(
                image11.created,
                1667676139,
                "Created date of image11 is incorrect."
            )
            XCTAssertFalse(
                image11.data.isEmpty,
                "Contents of image11 is empty."
            )

            image11.data.enumerated().forEach { (idx, response) in
                XCTAssertTrue(
                    response.image.contains("org-3JlqS7fDgniMfkzHfwwEdBm3/user-a1pfIvdAwqSA0RVdjzqH921M"),
                    "URL of image11 at index \(idx) isn't valid."
                )
            }

            XCTAssertEqual(
                image0Parameter.numberOfImages,
                1,
                "Image0's parameters wasn't set correctly."
            )
            XCTAssertEqual(
                image0.created,
                1667661280,
                "Created date of image0 is incorrect."
            )
            XCTAssertFalse(
                image0.data.isEmpty,
                "Contents of image0 is empty."
            )
            XCTAssertTrue(
                image0.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of image0 URL isn't valid."
            )

            XCTAssertEqual(
                imageNegative1Parameter.numberOfImages,
                1,
                "imageNegative1's parameters wasn't set correctly."
            )
            XCTAssertEqual(
                imageNegative1.created,
                1667661280,
                "Created date of imageNegative1 is incorrect."
            )
            XCTAssertFalse(
                imageNegative1.data.isEmpty,
                "Contents of imageNegative1 is empty."
            )
            XCTAssertTrue(
                imageNegative1.data[0].image.contains("img-byoTBAgSaGlyyTCGjnFhbSVx.png"),
                "Contents of imageNegative1 URL isn't valid."
            )
        } catch {
            XCTFail("IMAGE NUMBER TEST FAILED WITH ERROR: \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToReturnEmbeddingsForInput() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()
            let embeddingsParam = EmbeddingsParameters(
                model: "text-similarity-babbage-001",
                input: "The food was delicious and the waiter..."
            )

            // When
            let embeddingsResponse = try await mockOpenAI.createEmbeddings(
                parameters: embeddingsParam
            )

            // Then
            XCTAssertEqual(
                embeddingsResponse.object,
                .list,
                "Embeddings Response is not a list object."
            )
            XCTAssertEqual(
                embeddingsResponse.data[0].object,
                .embedding,
                "Embeddings data is not an embedding object."
            )
            XCTAssertEqual(
                embeddingsResponse.data[0].embedding.count,
                2048,
                "Embeddings data doesn't contain correct amount of floats."
            )
            XCTAssertEqual(
                embeddingsResponse.data[0].embedding[0],
                0.0028667077,
                "Embeddings data isn't correct."
            )
            XCTAssertEqual(
                embeddingsResponse.data[0].index,
                0,
                "Embeddings data index isn't correct."
            )
            XCTAssertEqual(
                embeddingsResponse.usage.promptTokens,
                8,
                "Prompt token amount isn't correct."
            )
            XCTAssertEqual(
                embeddingsResponse.usage.totalTokens,
                8,
                "Total token amount isn't correct."
            )
        } catch {
            XCTFail("EMBEDDINGS CREATION FAILED WITH ERROR - \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToReturnListedFiles() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            // When
            let filesResponse = try await mockOpenAI.listFiles()

            // Then
            XCTAssertEqual(
                filesResponse.object,
                .list,
                "Files Response isn't list object."
            )
            XCTAssertEqual(
                filesResponse.data[0].id,
                "file-uvdyS3qukzhVrcvxOcjk0Xss",
                "File ID isn't correct."
            )
            XCTAssertEqual(
                filesResponse.data[0].object,
                .file,
                "File isn't file object."
            )
            XCTAssertEqual(
                filesResponse.data[0].purpose,
                "fine-tune",
                "File Purpose isn't correct."
            )
            XCTAssertEqual(
                filesResponse.data[0].filename,
                "sampleData.jsonl",
                "File name isn't correct"
            )
            XCTAssertEqual(
                filesResponse.data[0].bytes,
                18950,
                "File size isn't correct."
            )
            XCTAssertEqual(
                filesResponse.data[0].createdAt,
                1668098746,
                "File creation date isn't correct."
            )
            XCTAssertEqual(
                filesResponse.data[0].status,
                .processed,
                "File status isn't correct."
            )
            XCTAssertNil(
                filesResponse.data[0].statusDetails,
                "File status details isn't nil."
            )
        } catch {
            XCTFail("LIST FILES FAILED WITH ERROR - \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToDeleteFileAndRespondWithResponse() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            // When
            let deleteFileResponse = try await mockOpenAI.deleteFile(
                fileId: "file-XjGxS3KTG0uNmNOK362iJua3"
            )

            // Then
            XCTAssertEqual(
                deleteFileResponse.id,
                "file-XjGxS3KTG0uNmNOK362iJua3",
                "File ID isn't correct."
            )
            XCTAssertEqual(
                deleteFileResponse.object,
                .file,
                "File isn't file object."
            )
            XCTAssertTrue(
                deleteFileResponse.deleted,
                "File isn't deleted."
            )
        } catch {
            XCTFail("DELETE FILE FAILED WITH ERROR - \(error)")
        }
    }

    func testThatVerifiesOpenAIIsAbleToSendContentPolicyResult() async {
        do {
            // Given
            let mockOpenAI = MockOpenAI()

            let contentPolicyParameter = ContentPolicyParameters(
                input: "I want to kill them."
            )

            // When
            let contentPolicyResult = try await mockOpenAI.checkContentPolicy(
                parameters: contentPolicyParameter
            )

            // Then
            XCTAssertEqual(
                contentPolicyResult.id,
                "modr-69OQBfTkTYrcLo7k3oL3PxmpkUeoL",
                "Content Policy ID doesn't match."
            )
            XCTAssertEqual(
                contentPolicyResult.model,
                "text-moderation-003",
                "Content Policy Model doesn't match."
            )
            XCTAssertFalse(
                contentPolicyResult.results.isEmpty,
                "Content Policy Result is empty."
            )
            XCTAssertEqual(
                contentPolicyResult.results[0].flagged,
                true,
                "Content Policy Flag doesn't match."
            )
            XCTAssertEqual(
                contentPolicyResult.results[0].categories.hate,
                true,
                "Content Policy Category doesn't match."
            )
            XCTAssertEqual(
                contentPolicyResult.results[0].categoryScores.hate,
                0.4068171977996826,
                "Content Policy Category Score doesn't match."
            )
        } catch {
            XCTFail("CONTENT POLICY TEST FAILED WITH ERROR: \(error)")
        }
    }
}
