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
typealias CodeTuple     = (id: String, name: String, index: Int)
typealias CodesId       = KinveyClient.CodesId
typealias RolesId       = KinveyClient.RolesId
typealias ActionsID     = KinveyClient.ActionsId
typealias SectionsID    = KinveyClient.SectionsId

extension KinveyClient {
    
    // MARK: Constants
    /// Constantes utilizadas en Kinvey
    struct Constants {
        static let BaseURL = "https://baas.kinvey.com"
        
        // Production:
//        static let AppKey = "kid_r1xTB_RD"
//        static let AppSecret = "d102c0ea18b04e65872e9706f6205299"
        
        //uploadFiles development
        static let AppKey = "kid_rJIZClLNg"
        static let AppSecret = "1ef2120cadd94c0eb82a06c1f50c8868"
        
        // Development:
//        static let AppKey = "kid_ByMzbaYT"
//        static let AppSecret = "797798c3c8594aedabf32beba21cd1ac"
        
        //Production
        static let MasterKey = "Basic a2lkX3IxeFRCX1JEOjFlYjFjMzY1MDdhODRjOWE5ZDUwY2EzMmIwNWQ0MTEw"
        
        //Develop:
//        static let MasterKey = "Basic a2lkX0J5TXpiYVlUOjlmZGU4ZmNmOGM4MzQ2ODRhNTkwZTFhMzZmZjg1MjZi"
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
    
    // MARK: Nombre de la "Tablas" que están en Kinvey
    struct CollectionNames {
        static let Action               = "Action"
        static let Agreement            = "Agreement"
        static let AgreementLog         = "AgreementLog"
        static let Appointment          = "Appointment"
        static let Code                 = "Code"
        static let CodeType             = "CodeType"
        static let CommentApproval      = "CommentApproval"
        static let Commitment           = "Commitment"
        static let CommitmentDocument   = "CommitmentDocument"
        static let CommitmentLog        = "CommitmentLog"
        static let Information          = "Information"
        static let InformationLog       = "InformationLog"
        static let KinveyGroup          = "KinveyGroup"
        static let Meeting              = "Meeting"
        static let MeetingDocument      = "MeetingDocument"
        static let Organization         = "Organization"
        static let Participant          = "Participant"
        static let Permission           = "Permission"
        static let Responsibility       = "Responsibility"
        static let Role                 = "Role"
        static let RoleAction           = "RoleAction"
        static let RoleSection          = "RoleSection"
        static let Section              = "Section"
        static let Team                 = "Team"
        static let Users                = "user"
    }
    
    // MARK: Métodos CRUD (create, read, update, delete)
    struct HTTPMethods {
        static let DELETE   = "DELETE"
        static let GET      = "GET"
        static let POST     = "POST"
        static let PUT      = "PUT"
    }
    
    //MARK: - Code names group by CodeType
    struct AnimoReunion {
        
        static let Bueno    = "Bueno"
        static let Malo     = "Malo"
        static let Regular  = "Regular"
        
        static let allValues = [Bueno, Regular, Malo]
    }
    
    struct CodesId {
        
        static let aprobado             = (id: "PxcuwSa2A0", name: "APROBADO", index: 1)
        static let acuerdo              = (id: "6jOWOH0vQE", name: "Acuerdos", index: 1)
        static let aprobador            = (id: "ZAl7F8DgT2", name: "Aprobador", index: 1)
        static let bueno                = (id: "jqathuiMXY", name: "Bueno", index: 0)
        static let cliente              = (id: "TKZiEZXkJa", name: "CLIENTE", index: 3)
        static let clienteSupervisor    = (id: "KVh6YgnJeT", name: "CLIENTESUPERVISOR", index: 4)
        static let colaborador          = (id: "hzMzgqxq9y", name: "COLABORADOR", index: 2)
        static let cancelado            = (id: "l4Esrp8CS6", name: "Cancelado", index: 2)
        static let compromisos          = (id: "zgMVmGv7xp", name: "Compromisos", index: 0)
        static let consultado           = (id: "vbnX8oiXyq", name: "Consultado", index: 3)
        static let ejecucion            = (id: "xjIPLTooZB", name: "En Ejecución", index: 0)
        static let info                 = (id: "Z5HTqNv88r", name: "Info", index: 2)
        static let informado            = (id: "n8Esi6CKGr", name: "Informado", index: 2)
        static let jefeSupervisor       = (id: "5v7P54Jeaa", name: "JEFESUPERVISOR", index: 0)
        static let malo                 = (id: "9MNVpZ8V9P", name: "Malo", index: 2)
        static let minuta               = (id: "XG0m6aGwHe", name: "Minuta", index: 0)
        static let noVigente            = (id: "ixYfyBfvR4", name: "NO VIGENTE", index: 1)
        static let porAprobar           = (id: "oqLizweLnI", name: "POR APROBAR", index: 0)
        static let rechazado            = (id: "n75MLi3wRY", name: "RECHAZADO", index: 2)
        static let regular              = (id: "87I41cgL6C", name: "Regular", index: 1)
        static let responsable          = (id: "ck9pEYFLEF", name: "Responsable", index: 0)
        static let supervisor           = (id: "C70JSPHxFt", name: "SUPERVISOR", index: 1)
        static let terminado            = (id: "LUDakj7BMI", name: "Terminado", index: 3)
        static let vigente              = (id: "wvooP3o2Pq", name: "Vigente", index: 0)
        
        static let porAprobarComment    = (id: "9hZ8ZMtBKc", name: "POR APROBAR", index: 0)
        static let aprobadoComment      = (id: "aRkIybIZhG", name: "APROBADO", index: 1)
        static let rechazadoComment     = (id: "isb2ktWovM", name: "RECHAZADO", index: 2)
        
        
        
        static let allCodes = [aprobado,acuerdo,aprobador,bueno,
                               cliente,clienteSupervisor,colaborador,cancelado,
                               compromisos,consultado,ejecucion,info,informado,
                               jefeSupervisor,malo,noVigente,porAprobar,rechazado,
                               regular,responsable,supervisor,terminado,vigente,
                               porAprobarComment, aprobadoComment, rechazadoComment]
        
        static func getcodeByID(_ id: String) -> (id: String, name: String, index: Int){
            for code in allCodes{
                if code.id == id {
                    return code
                }
            }
            return allCodes.first!
        }
        
        static func getcodeByName(_ name: String) -> (id: String, name: String, index: Int){
            for code in allCodes{
                if code.name == name {
                    return code
                }
            }
            return allCodes.first!
        }
        
    }
    
    struct RolesId{
        
        //Roles:
        static let admin        = (id: "579f6e69cdf83c187d8bca8e", name: "Admin")
        static let cliente      = (id: "5796836945b0932273eaf1e8", name: "Cliente")
        static let clienteSup   = (id: "57968706eb4d27917e25d58a", name: "SupervisorCliente")
        static let jefeSup      = (id: "5796863b67f937927e187fd8", name: "JefeSupervisor")
        static let colaborador  = (id: "5796835962b211ec6184d1a8", name: "Colaborador")
        static let supervisor   = (id: "579683601c808809034a4397", name: "Supervisor")
        
        static let allRoles = [admin, cliente, clienteSup, jefeSup, colaborador, supervisor]
        
        static func getRoleByID(_ id: String) -> (id: String, name: String) {
            for role in allRoles{
                if role.id == id {
                    return role
                }
            }
            return allRoles.first!
        }
        
        static func getRoleByName(_ name: String) -> (id: String, name: String) {
            for role in allRoles{
                if role.name == name {
                    return role
                }
            }
            return allRoles.first!
        }
    }
    
    struct ActionsId{
        static let allTeams     = (id: "579f6d9efe239a0a70363f12", name: "AllTeams"     , app: "IPAD")
        static let createMember = (id: "57d02c4228d5540e0b8f8605", name: "CreateMember" , app: "IPAD")
        static let createGuest  = (id: "57d02c54e6d6dd7b7b9de8c1", name: "CreateGuests" , app: "IPAD")
        static let createTeam   = (id: "57d02d1dc510d05d381b8be2", name: "CreateTeam"  , app: "IPAD")
        static let createMeeting = (id: "57d02d25da608f8b7324f4f8", name: "CreateMeeting", app: "IPAD")
    }
    
    struct SectionsId{
        static let allTeams     = (id: "57d2c78c7a91c10308c4bdbd", name: "AllTeams"     , app: "IPAD")
        static let createMember = (id: "57d2c1bceb47ef5309e6283b", name: "CreateMember" , app: "IPAD")
        static let createGuest  = (id: "57d2c1b287cccc2c2f3cb442", name: "CreateGuest" , app: "IPAD")
        static let createTeam   = (id: "57d2c16f69c0310a1e7b16bd", name: "CreateTeam"  , app: "IPAD")
        static let createMeeting = (id: "57d2c17d87cccc2c2f3cb13c", name: "CreateMeeting", app: "IPAD")
        static let editMember = (id: "57d96523780bf11948ebec91", name: "editMember", app: "IPAD")
    }
    
    func getCodeById(_ id: String) -> (id: String, name: String, index: Int)?{
        let codes = CodesId.allCodes.filter {$0.id == id}
        
        if !codes.isEmpty{
            return codes.first!
        }else{
            return nil
        }
    }
    
}
