//
//  KinveyErrors.swift
//  buohIpad
//
//  Created by Rodrigo Astorga on 27-07-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

class KinveyErrors {
    //TODO: manejadores de errores
}

enum KVErrorTitle: String {
    case ParameterValueOutOfRange           //400   The value specified for one of the request parameters is out of range
    case InvalidQuerySyntax                 //400	The query string in the request has an invalid syntax
    case MissingQuery                       //400	The request is missing a query string
    case JSONParseError                     //400	Unable to parse the JSON in the request
    case MissingRequestHeader               //400	The request is missing a required header
    case IncompleteRequestBody              //400	The request body is either missing or incomplete
    case FeatureUnavailable                 //400	Requested functionality is unavailable in this API version
    case CORSDisabled                       //400	Cross Origin Support is disabled for this application
    case APIVersionNotAvailable             //400	This API version is not available for your app. Please retry your request with a supported API version
    case BadRequest                         //400	Unable to understand request
    case BLRuntimeError                     //400	The Business Logic script has a runtime error. See debug message for details
    case InvalidCredentials                 //401	Invalid credentials. Please retry your request with correct credentials
    case InsufficientCredentials            //401	The credentials used to authenticate this request are not authorized to run this operation. Please retry your request with appropriate credentials
    case WritesToCollectionDisallowed       //403	This collection is configured to disallow any modifications to an existing entity or creation of new entities
    case IndirectCollectionAccessDisallowed //403	Please use the appropriate API to access this collection for this app backend
    case AppProblem                         //403	There is a problem with this app backend that prevents execution of this operation. Please contact support@kinvey.com for assistance
    case EntityNotFound                     //404	This entity not found in the collection
    case CollectionNotFound                 //404	This collection not found for this app backend
    case AppNotFound                        //404	This app backend not found
    case UserNotFound                       //404	This user does not exist for this app backend
    case BlobNotFound                       //404	This blob not found for this app backend
    case UserAlreadyExists                  //409	This username is already taken. Please retry your request with a different username
    case StaleRequest                       //409	The time window for this request has expired
    case KinveyInternalErrorRetry           //500	The Kinvey server encountered an unexpected error. Please retry your request
    case KinveyInternalErrorStop            //500	The Kinvey server encountered an unexpected error. Please contact support@kinvey.com for assistance
    case DuplicateEndUsers                  //500	More than one user registered with this username for this application. Please contact support@kinvey.com for assistance
    case APIVersionNotImplemented           //501	This API version is not implemented. Please retry your request with a supported API version
    case APIVersionNotAvailable2             //501	This API version is not available for your app. Please retry your request with a supported API version
    
    case BLSyntaxError                      //550	The Business Logic script has a syntax error(s). See debug message for details
    case BLTimeoutError                     //550	The Business Logic script did not complete in time. See debug message for details
    
    case BLViolationError                   //550	The Business Logic script violated a constraint. See debug message for details
    case BLInternalError                    //550	The Business Logic script did not complete. See debug message for details
}

enum KVErrorDescription: String {
    case ParameterValueOutOfRange           = "The value specified for one of the request parameters is out of range"
    case InvalidQuerySyntax                 = "The query string in the request has an invalid syntax"
    case MissingQuery                       = "The request is missing a query string"
    case JSONParseError                     = "Unable to parse the JSON in the request"
    case MissingRequestHeader               = "The request is missing a required header"
    case IncompleteRequestBody              = "The request body is either missing or incomplete"
    case FeatureUnavailable                 = "Requested functionality is unavailable in this API version"
    case CORSDisabled                       = "Cross Origin Support is disabled for this application"
    case APIVersionNotAvailable             = "This API version is not available for your app. Please retry your request with a supported API version"
    case BadRequest                         = "Unable to understand request"
    case BLRuntimeError                     = "The Business Logic script has a runtime error. See debug message for details"
    case InvalidCredentials                 = "Invalid credentials. Please retry your request with correct credentials"
    case InsufficientCredentials            = "The credentials used to authenticate this request are not authorized to run this operation. Please retry your request with appropriate credentials"
    case WritesToCollectionDisallowed       = "This collection is configured to disallow any modifications to an existing entity or creation of new entities"
    case IndirectCollectionAccessDisallowed = "Please use the appropriate API to access this collection for this app backend"
    case AppProblem                         = "There is a problem with this app backend that prevents execution of this operation. Please contact support@kinvey.com for assistance"
    case EntityNotFound                     = "This entity not found in the collection"
    case CollectionNotFound                 = "This collection not found for this app backend"
    case AppNotFound                        = "This app backend not found"
    case UserNotFound                       = "This user does not exist for this app backend"
    case BlobNotFound                       = "This blob not found for this app backend"
    case UserAlreadyExists                  = "This username is already taken. Please retry your request with a different username"
    case StaleRequest                       = "The time window for this request has expired"
    case KinveyInternalErrorRetry           = "The Kinvey server encountered an unexpected error. Please retry your request"
    case KinveyInternalErrorStop            = "The Kinvey server encountered an unexpected error. Please contact support@kinvey.com for assistance"
    case DuplicateEndUsers                  = "More than one user registered with this username for this application. Please contact support@kinvey.com for assistance"
    case APIVersionNotImplemented           = "This API version is not implemented. Please retry your request with a supported API version"
    case BLSyntaxError                      = "The Business Logic script has a syntax error(s). See debug message for details"
    case BLTimeoutError                     = "The Business Logic script did not complete in time. See debug message for details"
    case BLViolationError                   = "The Business Logic script violated a constraint. See debug message for details"
    case BLInternalError                    = "The Business Logic script did not complete. See debug message for details"
}

//example of response kinvey:
/*
 HTTP/1.1 401 Unauthorized
 Content-Type: application/json
 {
 “error”: “InsufficientCredentials”
 “description”: “The credentials used to authenticate this request are not authorized to run this operation. Please retry your request with appropriate credentials”
 “debug”: “Please authenticate as an app End User or as the app admin using the Master secret to run this operation”
 }
 */