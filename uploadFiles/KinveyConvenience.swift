//
//  KinveyConvenience.swift
//  buohIpad
//
//  Created by Rodrigo Astorga on 17-06-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import CoreData


// MARK: - Auth User
extension KinveyClient {
    
   
    
}

// MARK: - Read (queries from Kinvey)
extension KinveyClient {

    

}

// MARK: - Write in Kinvey
extension KinveyClient {

    fileprivate func save(_ path: URL, HTTPMethod: String = HTTPMethods.POST, body: [String: AnyObject],  completionForSave: @escaping completionData) {
        
        taskForMethod(path, HTTPMethod: HTTPMethod, HTTPBody: body, completionHandler: completionForSave)
    }
    
//    func saveCommitmentLog(_ commitmentLog: CommitmentLog,
//                           completion: @escaping (_ success: Bool, _ commitmentLog: CommitmentLog?, _ error : NSError?) -> Void){
//        
//        var httpMethod = HTTPMethods.POST
//        // 1. make URL path
//        var urlPathString = CommonHelpers.subtituteKeyInMethod(Paths.CollectionDataStore, key: ParameterKeys.CollectionName, value: CollectionNames.CommitmentLog)!
//        
//        if let id = commitmentLog.id , id != "" {
//            urlPathString += "\(id)"
//            httpMethod = HTTPMethods.PUT
//        }
//        
//        // 2. Prepare data for save
//        var dictCommitmentLog = CommitmentLog.toJSON(commitmentLog: commitmentLog)
//        
//        if let orgID = commitmentLog.meeting?.team?.organization?.id {
//            dictCommitmentLog["_acl"] = aclForOrganization(organizationId: orgID) as AnyObject?
//        }
//        
//        // 3. Make all url
//        guard let url = kinveyURL(urlPathString) else {
//            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Hubo un problema al generar url para guardado."]
//            let err = NSError(domain: "InvalidNSURL", code: 2, userInfo: userInfo)
//            completion(false, nil, err)
//            return
//        }
//        
//        taskForMethod(url, HTTPMethod: httpMethod, HTTPBody: dictCommitmentLog) { (result, error) in
//            
//            guard error == nil else{
//                DispatchQueue.main.async {
//                    completion(false, nil, error!)
//                }
//                return
//            }
//            
//            if let result = result as? [String: AnyObject]{
//                DispatchQueue.main.async {
//                    commitmentLog.id = (result[User.Keys.id] as! String)
//                    completion(true, commitmentLog, nil)
//                }
//            }else {
//                DispatchQueue.main.async {
//                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: "No se pudo leer la información luego de guardar el compromiso para la reunión"]
//                    let err = NSError(domain: "saveCommitmentLogBadFormat", code: 5, userInfo: userInfo)
//                    completion(false, nil, 
//                               err)
//                }
//            }
//            return
//        }
//        
//    }

  
 
    


}

// MARK: - Utilities: ACL
extension KinveyClient{
    
//    /// genera el acl para cualquier elemento que pertenece a una organización. Es necesario pasarle como parámetro el id de la organización,
//    /// debido a que por default el grupo de usuarios que accedera a la información serán todos los que pertenecen
//    /// a una organización.
//    func aclForOrganization( organizationId: String) -> [String: AnyObject] {
//        let idGroup = "GRP_ORG_" + organizationId
//        
//        let groups: [String: [String]] = [
//            "r": [idGroup],
//            "w": [idGroup]
//                //"r": ["groupId_1", "groupId_2"],
//                 //"w": ["groupId_3", "groupId_4"]
//        ]
//        
//        let aclDictionary: [String: AnyObject] = [
//            "gr": false as AnyObject,            //"r": ["id_user1","id_user2"],
//            "gw": false as AnyObject,            //"w": ["id_user3","id_user4"],
//            "groups": groups as AnyObject
//        ]
//        
//        return aclDictionary
//    }
//    //DICTIONARY
//    
//    func changeStateCommentApproval(){
//        KinveyClient.sharedInstance().getAllCommentsApproval { (commentsApprovalResponse, error) in
//            guard error == nil else {
//                print(error ?? "error al cambiar estado de commentApproval")
//                return
//            }
//            
//            if let commentsApprovalResponse = commentsApprovalResponse {
//                
//                var cambios = 0
//                for comment in commentsApprovalResponse {
//                    
//                    if comment.state!.id! == KinveyClient.CodesId.aprobado.id {
//                        cambios += 1
//                        comment.state!.id = KinveyClient.CodesId.aprobadoComment.id
//                    }else if comment.state!.id! == KinveyClient.CodesId.rechazado.id {
//                        cambios += 1
//                        comment.state!.id = KinveyClient.CodesId.rechazadoComment.id
//                    }else if comment.state!.id! == KinveyClient.CodesId.porAprobar.id {
//                        cambios += 1
//                        comment.state!.id = KinveyClient.CodesId.porAprobarComment.id
//                    }
//                }
//                print(cambios)
//                
//            }
//        }
//    }
//    
//    func checkResponsibilitiesInCommitment(_ commitment: Commitment, completion: @escaping completionSuccess){
//        
//        if let responsibilitiesObjects = commitment.responsibilities,
//            let responsibilitiesArray = responsibilitiesObjects.array as? [Responsibility] {
//            
//            let totalResponsibilities = responsibilitiesArray.count
//            var countOfResponsibilities = (success: 0, error: 0)
//            
//            func total() -> Int{
//                return countOfResponsibilities.success + countOfResponsibilities.error
//            }
//            
//            func checkTotal() -> Bool{
//                return total() == totalResponsibilities
//            }
//            
//            for responsibility in responsibilitiesArray{
//                
//                if let responsibilityTemp = TemporalData.sharedInstance().responsibilities.searchResponsibilityBy(user: responsibility.user!, role: responsibility.role!){
//                    responsibility.id = responsibilityTemp.id
//                    countOfResponsibilities.success += 1
//                    if checkTotal(){
//                        if countOfResponsibilities.error != 0{
//                            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Hubo un error intentando guardar las responsabilidades"]
//                            let err = NSError(domain: "BadResponsibility", code: 20, userInfo: userInfo)
//                            completion(false, err)
//                        }else{
//                            completion(true, nil)
//                        }
//                        
//                    }
//                }else{
//                    KinveyClient.sharedInstance().saveResponsibility(responsibility, completion: { (responsibilityResponse, error) in
//                        if responsibilityResponse != nil{
//                            countOfResponsibilities.success += 1
//                        }else{
//                            countOfResponsibilities.error += 1
//                        }
//                        
//                        if checkTotal() {
//                            if countOfResponsibilities.error != 0{
//                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: "Hubo un error intentando guardar las responsabilidades"]
//                                let err = NSError(domain: "BadResponsibility", code: 20, userInfo: userInfo)
//                                completion(false, err)
//                            }else{
//                                completion(true, nil)
//                            }
//                        }
//                    })
//                }
//            }
//            
//        }
//    }
//    
//    func checkUsernameExists(_ username: String, handler: @escaping (_ success: Bool, _ error: NSError? ) -> Void){
//            
//        let httpMethod = HTTPMethods.POST
//        // 1. make URL path
//        let urlPathString = "\(Constants.BaseURL)/rpc/\(Constants.AppKey)/check-username-exists"
//        
//        let dict: [String: AnyObject] = ["username": username as AnyObject]
//        
//        // 3. Make all url
//        guard let url = kinveyURL(urlPathString) else {
//            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "No se pudo obtener url de responsabilidades"]
//            let err = NSError(domain: "InvalidNSURL", code: 2, userInfo: userInfo)
//            handler(false, err)
//            return
//        }
//        
//        // 4. Make task for URL
//        taskForMethod(url, HTTPMethod: httpMethod, HTTPBody: dict, withAppCredentials: appCredentials) { (result, error) in
//            
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    handler(false, error!)
//                }
//                return
//            }
//            // 5. Check for errors and data
//            if let result = result as?  [String: AnyObject],
//                let exists = result["usernameExists"] as? Bool {
//
//                print("in checkUsernameExists:")
//                handler(exists, nil)
//
//            }else {
//                
//                let userInfo:[String:String] = [NSLocalizedDescriptionKey: "No se pudo leer la información obtenida para los compromisos"]
//                let err = NSError(domain: "checkUsernameExistsBadFormat", code: 5, userInfo: userInfo)
//                handler(false, err)
//            }
//            return
//        }
//    }
    
    // MARK: - Upload files
    func uploadFiles(fileName: String, data: NSData,  completion: @escaping (_ success: Bool, _ error: Error?) -> Void){
        
        let baseURL = "https://baas.kinvey.com/blob/kid_rJIZClLNg/"

        let body: [String: AnyObject] = [
            "_filename": fileName as AnyObject,
            "mimeType": "image/png" as AnyObject
        ]

        let httpMethod = HTTPMethods.POST

        guard let newURL = kinveyURL(baseURL) else {
            let userInfo:[String:String] = [NSLocalizedDescriptionKey: "No se pudo leer la información luego de guardar el compromiso"]
            let err = NSError(domain: "saveAgreementBadFormat", code: 5, userInfo: userInfo)
            completion(false, err as Error)
            return
        }

        taskForMethod(newURL, HTTPMethod: httpMethod, HTTPBody: body) { (result, error) in
            
            guard error == nil else {
                DispatchQueue.main.async{
                    
                    completion(false, error! as Error)
                }
                return
            }
            
            if let result = result as? [String: AnyObject]{
                
                DispatchQueue.main.async {

                    print(result)
                    
                    if let uploadURL = result["_uploadURL"] as? String{
                        print(uploadURL)
                        self.putPhoto(url: uploadURL, data: data, completion: { (anyobject, error) in
                            guard error == nil else {
                                print(error!)
                                completion(false, error! as Error)
                                return
                            }
                            
                            if let anyobject = anyobject {
                                print(anyobject)
                                completion(true, nil)
                            }else{
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: "error de formato al leer la información luego de guardar en Files Google (al utilizar función putPhoto)"]
                                let err = NSError(domain: "saveFileBadFormat", code: 5, userInfo: userInfo)
                                completion(false, err)
                            }
                        })
                    }
                }
                
            }else {
                DispatchQueue.main.async {
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: "error de formato al leer la información luego de guardar en Files Kinvey"]
                    let err = NSError(domain: "saveFileBadFormat", code: 5, userInfo: userInfo)
                    completion(false, err)
                }
                
            }
        }
        
    }
    
    func putPhoto(url: String, data: NSData,  completion: @escaping (_ result: AnyObject?, _ error: Error?) -> Void){

        
        let httpMethod = HTTPMethods.PUT

        guard let newURL = kinveyURL(url) else {
            return
        }
        
        // 1. Configuración del request
        var request = URLRequest(url: newURL)
        request.httpMethod = httpMethod
//        request.addValue(ParameterKeys.AppJSon, forHTTPHeaderField: ParameterKeys.ContentTypeJSon)
        request.addValue("\(data.length)", forHTTPHeaderField: "Content-Length")
        request.setValue(userCredentials, forHTTPHeaderField: ParameterKeys.Authorization)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        
        let task = session.uploadTask(with: request, from: data as Data) { (data, response, error) in
            DispatchQueue.main.async{
                
                
                func sendError(_ error: String) {
                    
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: error]
                    let err = NSError(domain: "InvalidParseInformation", code: 1, userInfo: userInfo)
                    completion(nil, err as Error )
                }
                
                /* GUARD: Was there an error? */
                guard (error == nil) else {
                    var message = ""
                    
                    let error = error as! NSError
                    switch error.code {
                    case -1001: //NSURLErrorDomain
                        message = "La solicitud tardó más de lo normal. Revise su conexión a Internet."
                    case -1003:
                        message = "No se pudo encontrar el servidor con el hostname especificado."
                    case -1005:
                        message = "La conexión a Internet se perdió."
                    case -1009:
                        message = "La conexión a Internet parace estar desactivada."
                    case 3840:
                        message = "No se encontró valor. "
                    default:
                        message = "Ocurrió un error durante su solicitud. Revise su conexión a internet.\nDescripción del problema: \(error.localizedDescription)"
                    }
                    sendError(message)
                    return
                }
                
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    sendError("Su solicitud no retornó datos")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                    
                    let codeError = (response as? HTTPURLResponse)?.statusCode
                    
                    
                    if JSONSerialization.isValidJSONObject(data) {
                        print("se puede serializar el error de status")
                    }else{
                        print("no se puede serializar el error de status")
                    }
                    // revisa el error en Kinvey:
                    let dataNew: AnyObject!
                    do{
                        dataNew = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                        
                        if let errorTitle = dataNew["error"] as? String,
                            let descriptionError = dataNew["description"] as? String{
                            
                            //Kinvey errors:
                            if let errorKinvey = KVErrorTitle(rawValue: errorTitle)
                            {
                                var message = ""
                                switch errorKinvey {
                                case .InvalidCredentials:
                                    message = "Credenciales Inválidas. El nombre de usuario y/o contraseña es incorrecta. Por favor intente nuevamente con credenciales válidas."
                                case .UserNotFound:
                                    message = "No se encontró usuario en la base de datos."
                                default:
                                    message = descriptionError
                                }
                                
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: message]
                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
                                completion(nil, err )
                                return
                            }else{
                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: descriptionError]
                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
                                completion(nil, err)
                                return
                            }
                        }
                        else if let descriptionError = dataNew["description"] as? String {
                            sendError(descriptionError)
                        }else{
                            sendError("Su solicitud retornó un código de estado distinto de 2xx!")
                        }
                    }catch {
                        sendError("Su solicitud retornó un código de estado distinto de 2xx!")
                        return
                    }
                    
                    
                    return
                }
                
                
                if JSONSerialization.isValidJSONObject(data) {
                    var parsedResult: AnyObject!
                    
                    
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                    } catch {
                        let userInfo:[String:String] = [NSLocalizedDescriptionKey : "Ups, No pudimos leer la información obtenida desde el servidor. Favor intente nuevamente. Si el problema persiste, contactar a soporte."]
                        let err = NSError(domain: "parseJSONWithCompletionHandler", code: 3, userInfo: userInfo)
                        completion(nil, err as Error)
                        return
                    }
                    
                    completion(parsedResult, nil)
                }else{
                    print("error al parsear info obtenida.")
                    let userInfo:[String:String] = [NSLocalizedDescriptionKey : "Ups, No pudimos leer la información obtenida desde el servidor. Favor intente nuevamente. Si el problema persiste, contactar a soporte."]
                    let err = NSError(domain: "parseJSONWithCompletionHandler", code: 3, userInfo: userInfo)
                    completion(nil, err as Error)
                }
                
                

                return
            }
        }

        task.resume()
        

        
    }
    
//    static func fileCreate( fileName: String, data: NSData){
//        
//        let baseURL = "/blob/kid_rJIZClLNg/"
//        var url = baseURL
//        var file = File()
//        
//        var body = "{\"_filename\":\"" + fileName + "\",\"size\":" + url + ",\"mimeType\":\"image/png\"}"//+ "\", \"photoJson\":" + files.json
//        //        dynamic resultCreateFile = KinveyBase.PostWithEncoded(url, body, KinveyConstant.encodedMaster);
//        //        var jsonResul = JObject.Parse(resultCreateFile);
//        //        string idFile = jsonResul._id;
//        //        string uploadUrl = jsonResul._uploadURL;
//        //
//        //        if (idFile != null) { PutFile(uploadUrl, data); }
//        //        return idFile;
//    }
    
}

////MARK: - Generación de Minuta:
//extension KinveyClient{
//
//    func generarPDF(_ meeting: Meeting, completion: @escaping completionSuccess){
//        
//        let teamID = meeting.team!.id!
//        let meetingID = meeting.id!
//        let token = KinveyClient.sharedInstance().onlyToken!
//        
////        let idMeeting = "?idTeam=\(teamID)&idMeeting=\(meetingID)&userToken=\(token)"
//        var postEndpoint = Paths.pdfURL //+ idMeeting
//        
////        let escapedToken = token.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//        
//        let characterSet = CharacterSet(charactersIn:"=\"#/%<>?@\\^`{|}+").inverted
//        let escapedToken2 = token.addingPercentEncoding(withAllowedCharacters: characterSet)
//        
//        let escapedTeamID = teamID.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        let escapedmeetingID = meetingID.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        
//        postEndpoint += "?idTeam=\(escapedTeamID!)"+"&"+"idMeeting=\(escapedmeetingID!)"+"&"+"userToken=\(escapedToken2!)"
//        
//        let urlRequest = URL(string: postEndpoint)!
//        
//        //3) Then create the data task:
//        let task = session.dataTask(with: urlRequest, completionHandler: {
//            (data, response, error) in
//            DispatchQueue.main.async{
//                guard error == nil else{
//                    print("error in generarPDF: se encontró un error en request")
//                    DispatchQueue.main.async{
//                        completion(false, error! as NSError?)
//                    }
//                    return
//                }
//                
//                guard let data = data else {
//                    print("error in generarPDF: no hay data")
//                    DispatchQueue.main.async{
//                        let userInfo:[String:String] = [NSLocalizedDescriptionKey: "La respuesta del servidor no trajo datos"]
//                        let err = NSError(domain: "NoDataResponse", code: 3, userInfo: userInfo)
//                        completion(false, err)
//                    }
//                    return
//                }
//                
//                guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
//                    print("error in generarPDF: respuesta inválida del servidor")
//                    
//                    let codeError = (response as? HTTPURLResponse)?.statusCode
//                    
//                    // revisa el error en Kinvey:
//                    let descriptionError = "respuesta inválida del servidor"
//                    let dataNew: AnyObject!
//                    do{
//                        dataNew = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
//                        
//                        
//                        if let errorTitle = dataNew["error"] as? String,
//                            let descriptionError = dataNew["description"] as? String{
//                            
//                            //Kinvey errors:
//                            if let errorKinvey = KVErrorTitle(rawValue: errorTitle)
//                            {
//                                var message = ""
//                                switch errorKinvey {
//                                case .InvalidCredentials:
//                                    message = "Credenciales Inválidas. El nombre de usuario y/o contraseña es incorrecta. Por favor intente nuevamente con credenciales válidas."
//                                case .UserNotFound:
//                                    message = "No se encontró usuario en la base de datos."
//                                default:
//                                    message = descriptionError
//                                }
//                                
//                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: message]
//                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
//                                completion(false, err )
//                                return
//                            }else{
//                                let userInfo:[String:String] = [NSLocalizedDescriptionKey: descriptionError]
//                                let err = NSError(domain: errorTitle, code: codeError!, userInfo: userInfo)
//                                completion(false, err)
//                                return
//                            }
//                        }
//
//                    }catch {
//                        let userInfo:[String:String] = [NSLocalizedDescriptionKey: descriptionError]
//                        let err = NSError(domain: "InvalidStatusCode", code: codeError!, userInfo: userInfo)
//                        completion(false, err)
//                        return
//                    }
//                    return
//                }
//                
//                completion(true, nil)
//            }
//            
//
//        })
//        task.resume()
//    }
//    
//    func getAllUserGroups(_ handler: @escaping (_ success: Bool, _ groupIDs: [String]?, _ error: NSError? ) -> Void ) {
//        
//        let httpMethod = HTTPMethods.POST
//        // 1. make URL path
//        let urlPathString = "\(Constants.BaseURL)/rpc/\(Constants.AppKey)/custom/groupsIDs"
//        
//        let dict: [String: AnyObject] = [:]
//        // 3. Make all url
//        guard let url = kinveyURL(urlPathString) else {
//            return
//        }
//        
//        // 4. Make task for URL
//        taskForMethod(url, HTTPMethod: httpMethod, HTTPBody: dict, withAppCredentials: Constants.MasterKey) { (result, error) in
//
//            guard error == nil else {
//                DispatchQueue.main.async {
//                    handler(false, nil, error!)
//                }
//                return
//            }
//            // 5. Check for errors and data
//            if let groupsDict = result as? [ [String: AnyObject] ] {
//                DispatchQueue.main.async {
//                    print("inside of getCommitment")
//                    
//                    let group = groupsDict.map({ (dictionary: [String : AnyObject]) -> String in
//                        return (dictionary["_id"] as! String)
//                    })
//                    
//                    handler(true, group, nil)
//                    return
//                    
//                }
//                
//            }else {
//                DispatchQueue.main.async {
//                    let userInfo:[String:String] = [NSLocalizedDescriptionKey: "No se pudo leer la información obtenida para los compromisos"]
//                    let err = NSError(domain: "getCommitmentsBadFormat", code: 5, userInfo: userInfo)
//                    handler(false, nil, err)
//                    return
//                }
//                
//            }
//        }
//        
//    }
//}
//
