//
//  OpenAIProtocol.swift
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

public protocol OpenAIProtocol {
    // MARK: Models Functions
    /// List and describe the various models available in the API. You can refer to the [Models](https://beta.openai.com/docs/models)
    /// documentation to understand what models are available and the differences between them.

    /// Lists the currently available models, and provides basic information about each one such as the owner and availability.
    /// - Returns: A `ListModelResponse` object.
    func listModels() async throws -> ListModelResponse

    /// Retrieves a model instance, providing basic information about the model such as the owner and permissioning.
    /// - Parameter id: The `String` of ID of the model.
    /// - Returns: A `Model` object.
    func retrieveModel(modelId id: String) async throws -> Model


    // MARK: Completion Function
    /// Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.

    /// Using GPT3, Generate completions based on the input.
    /// - Parameter param: A `CompletionParameters` object containing the parameters for the call.
    /// - Returns: A `CompletionResponse` object.
    func generateCompletion(parameters param: CompletionParameters) async throws -> CompletionResponse

    /// Using GPT3, Generate completions based on the input. This function streams the output.
    /// - Parameter param: A `CompletionParameters` object containing the parameters for the call.
    /// - Returns: An `AsyncThrowingStream` with either a `CompletionResponse` object or an `Error` object.
    func generateCompletionStreaming(
        parameters param: CompletionParameters
    ) throws -> AsyncThrowingStream<CompletionResponse, Error>


    // MARK: Chat Function
    /// Creates a completion for the chat message

    /// Using ChatGPT, generate completions based on message history.
    /// - Parameter param: A `ChatParameters` object containing the parameters for the call.
    /// - Returns: A `ChatResponse` object.
    func generateChatCompletion(parameters param: ChatParameters) async throws -> ChatResponse

    /// Using ChatGPT, generate completions based on message history. This function is for users to stream data as its generated.
    /// - Parameter param: A `ChatParameters` object containing the parameters for the call.
    /// - Returns: An `AsyncThrowingStream` with either a `ChatResponse` object or an `Error` object.
    func generateChatCompletionStreaming(
        parameters param: ChatParameters
    ) throws -> AsyncThrowingStream<ChatResponse, Error>


    // MARK: Image Functions
    /// Given a prompt and/or an input image, the model will generate a new image.
    /// Related guide: [Image generation](https://beta.openai.com/docs/guides/images)

    /// Creates an image given a prompt.
    /// - Parameter param: An `ImageParameters` object containing the parameters for the call.
    /// - Returns: An `ImageResponse` object.
    func createImage(parameters param: ImageParameters) async throws -> ImageResponse

    /// Creates an edited or extended image given an original image and a prompt.
    /// - Parameter param: An `ImageEditParameters` object containing the parameters for the call.
    /// - Returns: An `ImageResponse` object.
    func generateImageEdits(parameters param: ImageEditParameters) async throws -> ImageResponse

    /// Creates a variation of a given image.
    /// - Parameter param: An `ImageVariationParameters` object containing the parameters for the call.
    /// - Returns: An `ImageResponse` object.
    func generateImageVariations(parameters param: ImageVariationParameters) async throws -> ImageResponse


    // MARK: Embeddings Function
    /// Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
    /// Relarted guide: [Embeddings](https://beta.openai.com/docs/guides/embeddings)

    /// Creates an embedding vector representing the input text.
    /// - Parameter param: An `EmbeddingsParameters` object containing the parameters for the call.
    /// - Returns: An `EmbeddingsResponse` object.
    func createEmbeddings(parameters param: EmbeddingsParameters) async throws -> EmbeddingsResponse


    // MARK: Audio Functions
    /// Get text from an audio source
    /// Related guide: [Speech to text](https://platform.openai.com/docs/guides/speech-to-text)

    /// Transcribes audio into the input language.
    /// - Parameter param: A `TranscriptionParameters` object containing the parameters for the call.
    /// - Returns: A `TranscriptionResponse` object.
    func createTranscription(parameters param: TranscriptionParameters) async throws -> TranscriptionResponse

    /// Translates audio into English.
    /// - Parameter param: A `TranscriptionParameters` object containing the parameters for the call.
    /// - Returns: A `TranscriptionResponse` object.
    func createTranslation(parameters param: TranscriptionParameters) async throws -> TranscriptionResponse


    // MARK: Files Functions
    /// Files are used to upload documents for training and fine-tuning models.

    /// Returns a list of files that belong to the user's organization.
    /// - Returns: A `ListFilesResponse` object.
    func listFiles() async throws -> ListFilesResponse

    /// Upload a file that contains document(s) to be used across various endpoints/features.
    /// Currently, the size of all the files uploaded by one organization
    /// can be up to 1 GB. Please contact us if you need to increase the storage limit.
    /// - Parameter param: A `UploadFileParameters` object containing the parameters for the call.
    /// - Returns: A `File` object.
    func uploadFile(parameters param: UploadFileParameters) async throws -> File

    /// Delete a file.
    /// - Parameter id: A `String` value representing the ID of the file.
    /// - Returns: A `DeleteObject` object.
    func deleteFile(fileId id: String) async throws -> DeleteObject

    /// Returns information about a specific file.
    /// - Parameter id: A `String` value representing the ID of the file.
    /// - Returns: A `File` object.
    func retrieveFile(fileId id: String) async throws -> File

    /// Returns the contents of the specified file.
    /// - Parameter id: A `String` value representing the ID of the file.
    /// - Returns: An array of `FineTuneTraining` objects.
    func retrieveFileContent(fileId id: String) async throws -> [FileContent]


    // MARK: Fine-tune Functions.
    /// Manage fine-tuning jobs to tailor a model to your specific training data.
    /// Related guide: [Fine-tune models](https://beta.openai.com/docs/guides/fine-tuning)

    /// Deletes the Fine-tune model from storage.
    /// - Parameter model: The string of the model's name being deleted.
    /// - Returns: A `DeleteObject` object.
    func deleteModel(model: String) async throws -> DeleteObject


    // MARK: Moderation Function
    /// Given a input text, outputs if the model classifies it as violating OpenAI's content policy.
    /// Related guide: [Moderations](https://beta.openai.com/docs/guides/moderation)

    /// Classifies if text violates OpenAI's Content Policy
    /// - Parameter param: A `ContentPolicyParameters` object containing parameters for the call.
    /// - Returns: A `ContentPolicyResponse` object.
    func checkContentPolicy(parameters param: ContentPolicyParameters) async throws -> ContentPolicyResponse
}
