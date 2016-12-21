//
//  KinveyConstants.swift
//  buohIpad
//
//  Created by Rodrigo Astorga on 17-06-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation

typealias Dictionary    = [String: AnyObject]
typealias KinveyRef     = [String: AnyObject]
typealias JSONKeys      = KinveyClient.JSONKeys
typealias JSONValue     = KinveyClient.JSONValues

extension KinveyClient {
    
    // MARK: Constants
    /// Constantes utilizadas en Kinvey
    struct Constants {
        static let BaseURL = "https://baas.kinvey.com"

        //uploadFiles development
        static let AppKey = "kid_rJIZClLNg"
        static let AppSecret = "1ef2120cadd94c0eb82a06c1f50c8868"
        
    }
    
    // MARK: Paths
    /// Rutas base para realizar operaciones con Kinvey. Por ejemplo, para acceder a los datos
    /// utilizamos la ruta: "Paths.CollectionDataStore" editando el collectionName por el 
    /// respectivo nombre de la tabla que se desea acceder.
    struct Paths {
        static let BaseDataStore        = Constants.BaseURL + "/appdata/\(Constants.AppKey)"
        static let BaseUsers            = Constants.BaseURL + "/user/\(Constants.AppKey)/"
        static let BaseGroups           = Constants.BaseURL + "/group/\(Constants.AppKey)/"
        static let BaseFiles            = Constants.BaseURL + "/blob/\(Constants.AppKey)/"
        static let CollectionDataStore  = Paths.BaseDataStore + "/:collectionName/"
        static let pdfURL               = "http://buoh.solu4b.com/Meeting/SharedMeeting"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let TimeOut  = 50.0

        static let Authorization    = "Authorization"
        static let Query            = "query"
        static let AppJSon          = "application/json"
        static let ContentTypeJSon  = "Content-Type"
        static let CollectionName   = ":collectionName"
        static let ResolveDepth     = "resolve_depth"
        static let Resolve          = "resolve"
        static let RetainReferences = "retainReferences"
    }
    
    struct ParamResponses {
        static let KinveyMetaData       = "_kmd"
        static let LastModifiedTime     = "lmt"
        static let EntityCreationTime   = "ect"
        static let Token                = "authtoken"
    }
    
    struct JSONKeys {
        
        static let Collection   = "_collection"
        static let Id           = "_id"
        static let Object       = "_obj"
        static let TypeOf       = "_type"
    }
    
    struct JSONValues {
        static let KVReference = "KinveyRef"
    }
    
    // MARK: Métodos CRUD (create, read, update, delete)
    struct HTTPMethods {
        static let DELETE   = "DELETE"
        static let GET      = "GET"
        static let POST     = "POST"
        static let PUT      = "PUT"
    }
    
}
