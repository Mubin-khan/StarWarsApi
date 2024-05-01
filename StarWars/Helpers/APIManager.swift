//
//  APIManager.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation
import Alamofire

enum DataError : Error {
    case invalidUrl
    case invalidResponse
    case serverError
    case unknownError
}

class APIManager {
    
    func request<T : Decodable>(urlString : String) async throws -> Result<T,DataError> {
       let response =  await AF.request(urlString, interceptor: .retryPolicy)
                               .serializingDecodable(T.self)
                               .response
        
        switch response.result {
        case .success(let res) : return .success(res)
        case .failure(let AFerr) : return .failure(checkError(err: AFerr))
        }
    }
    
    func checkError(err : AFError) -> DataError {
        switch err {
            //            case .createUploadableFailed(let error):
            //                debugPrint("Create Uploadable Failed, description: \(error.localizedDescription)")
            //            case .createURLRequestFailed(let error):
            //                debugPrint("Create URL Request Failed, description: \(error.localizedDescription)")
            //            case .downloadedFileMoveFailed(let error, let source, let destination):
            //                debugPrint("Downloaded File Move Failed, description: \(error.localizedDescription)")
            //                debugPrint("Source: \(source), Destination: \(destination)")
            //            case .explicitlyCancelled:
            //                debugPrint("Explicitly Cancelled - \(error.localizedDescription)")
        case .invalidURL(_):
            return DataError.invalidUrl
            //            case .multipartEncodingFailed(let reason):
            //                debugPrint("Multipart encoding failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .parameterEncodingFailed(let reason):
            //                debugPrint("Parameter encoding failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .parameterEncoderFailed(let reason):
            //                debugPrint("Parameter Encoder Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .requestAdaptationFailed(let error):
            //                debugPrint("Request Adaptation Failed, description: \(error.localizedDescription)")
            //            case .requestRetryFailed(let retryError, let originalError):
            //                debugPrint("Request Retry Failed")
            //                debugPrint("Original error description: \(originalError.localizedDescription)")
            //                debugPrint("Retry error description: \(retryError.localizedDescription)")
            //            case .responseValidationFailed(let reason):
            //                debugPrint("Response validation failed, description: \(error.localizedDescription)")
            //                switch reason {
            //                case .dataFileNil, .dataFileReadFailed:
            //                    debugPrint("Downloaded file could not be read")
            //                case .missingContentType(let acceptableContentTypes):
            //                    debugPrint("Content Type Missing: \(acceptableContentTypes)")
            //                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
            //                    debugPrint("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
            //                case .unacceptableStatusCode(let code):
            //                    debugPrint("Response status code was unacceptable: \(code)")
            //                default: break
            //                }
            //            case .responseSerializationFailed(let reason):
            //                debugPrint("Response serialization failed: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .serverTrustEvaluationFailed(let reason):
            //                debugPrint("Server Trust Evaluation Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .sessionDeinitialized:
            //                debugPrint("Session Deinitialized, description: \(error.localizedDescription)")
            //            case .sessionInvalidated(let error):
            //                debugPrint("Session Invalidated, description: \(error?.localizedDescription ?? "")")
            //            case .sessionTaskFailed(let error):
            //                debugPrint("Session Task Failed, description: \(error.localizedDescription)")
            //            case .urlRequestValidationFailed(let reason):
            //                debugPrint("Url Request Validation Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
        default : return DataError.unknownError
        }
    }
}

extension AFError {
    func checkError() -> DataError {
        switch self {
            //            case .createUploadableFailed(let error):
            //                debugPrint("Create Uploadable Failed, description: \(error.localizedDescription)")
            //            case .createURLRequestFailed(let error):
            //                debugPrint("Create URL Request Failed, description: \(error.localizedDescription)")
            //            case .downloadedFileMoveFailed(let error, let source, let destination):
            //                debugPrint("Downloaded File Move Failed, description: \(error.localizedDescription)")
            //                debugPrint("Source: \(source), Destination: \(destination)")
            //            case .explicitlyCancelled:
            //                debugPrint("Explicitly Cancelled - \(error.localizedDescription)")
        case .invalidURL(_):
            return DataError.invalidUrl
            //            case .multipartEncodingFailed(let reason):
            //                debugPrint("Multipart encoding failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .parameterEncodingFailed(let reason):
            //                debugPrint("Parameter encoding failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .parameterEncoderFailed(let reason):
            //                debugPrint("Parameter Encoder Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .requestAdaptationFailed(let error):
            //                debugPrint("Request Adaptation Failed, description: \(error.localizedDescription)")
            //            case .requestRetryFailed(let retryError, let originalError):
            //                debugPrint("Request Retry Failed")
            //                debugPrint("Original error description: \(originalError.localizedDescription)")
            //                debugPrint("Retry error description: \(retryError.localizedDescription)")
            //            case .responseValidationFailed(let reason):
            //                debugPrint("Response validation failed, description: \(error.localizedDescription)")
            //                switch reason {
            //                case .dataFileNil, .dataFileReadFailed:
            //                    debugPrint("Downloaded file could not be read")
            //                case .missingContentType(let acceptableContentTypes):
            //                    debugPrint("Content Type Missing: \(acceptableContentTypes)")
            //                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
            //                    debugPrint("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
            //                case .unacceptableStatusCode(let code):
            //                    debugPrint("Response status code was unacceptable: \(code)")
            //                default: break
            //                }
            //            case .responseSerializationFailed(let reason):
            //                debugPrint("Response serialization failed: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .serverTrustEvaluationFailed(let reason):
            //                debugPrint("Server Trust Evaluation Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
            //            case .sessionDeinitialized:
            //                debugPrint("Session Deinitialized, description: \(error.localizedDescription)")
            //            case .sessionInvalidated(let error):
            //                debugPrint("Session Invalidated, description: \(error?.localizedDescription ?? "")")
            //            case .sessionTaskFailed(let error):
            //                debugPrint("Session Task Failed, description: \(error.localizedDescription)")
            //            case .urlRequestValidationFailed(let reason):
            //                debugPrint("Url Request Validation Failed, description: \(error.localizedDescription)")
            //                debugPrint("Failure Reason: \(reason)")
        default : return DataError.unknownError
        }
    }
}

