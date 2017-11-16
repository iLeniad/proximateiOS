//
//  SQLSW4.swift
//  proximateiOS
//
//  Created by Daniel Cedeño García on 11/15/17.
//  Copyright © 2017 Proximate. All rights reserved.
//

import Foundation


class DB_Manager: NSObject {
    
    var db: OpaquePointer? = nil
    var statement: OpaquePointer? = nil
    
    
    override init() {
        super.init()
        
    }
    
    func close_database(_ base:String?){
        
        
        
        if db != nil {
            sqlite3_close(db)
        }
        
    }
    
    func open_database(_ base:String?){
        
        
        
        
        
        
        //print("vamos abrir la base \(base!)")
        
        let documents_path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let documents = Bundle.main.resourcePath
        
        let path = documents!.stringByAppendingPathComponent(base!)
        
        let path_documents = documents_path.stringByAppendingPathComponent(base!)
        
        // open database
        //print(path)
        
        
        
        
        
        let checkValidation = FileManager.default
        
        if (checkValidation.fileExists(atPath: path_documents))
        {
            // print("FILE AVAILABLE");
        }
        else
        {
            //  print("FILE NOT AVAILABLE");
            
            do {
                try checkValidation.copyItem(atPath: path, toPath: path_documents)
            }
                
            catch  {
                //print("error al copiar")
                
            }
            
        }
        
        
        /* let filemanager:NSFileManager = NSFileManager()
         let files = filemanager.enumeratorAtPath(NSHomeDirectory())
         while let file = files?.nextObject() {
         print(file)
         }
         */
        
        // open database
        
        /*  var db: COpaquePointer = nil
         if sqlite3_open(path, &db) != SQLITE_OK {
         print("error opening database")
         }
         */
        
        if sqlite3_open_v2(path_documents, &db, SQLITE_OPEN_READWRITE, nil) != SQLITE_OK {
            // print("error opening database")
        }
        else{
            // print("todo bien al abrir la base")
        }
        
    }
    
    
    func execute_query(_ sql:String?)->(Bool,String){
        
        
        
        if sqlite3_exec(db, sql!, nil, nil, nil) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            
            
            
            let errmsg = String(cString:sqlite3_errmsg(db))
            
            //print("error creating table: \(errmsg)")
            
            return (false,errmsg)
            
        }
        
        return (true,"OK")
        
    }
    
    
    func prepare_query( _ sql:String?)->(Bool,String){
        
        
        
        if sqlite3_prepare_v2(db, sql!, -1, &statement, nil) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            //print("error creating table: \(errmsg)")
            
            return (false,errmsg)
            
        }
        
        sqlite3_finalize(statement);
        
        return (true,"OK")
        
    }
    
    //insert bulk
    
    func insert_bulk(_ tabla:String,datos:[[String:AnyObject]])->(Bool,String){
        
        
        
        var sql_insert = "insert into '\(tabla)' ("
        
        let sql_nombre_columnas = "PRAGMA table_info('\(tabla)')"
        
        let resultado_nombre_columnas = select_query(sql_nombre_columnas)
        
        var columnas:[String]=[]
        
        var i = 0
        
        for renglon in resultado_nombre_columnas {
            
            
            columnas.append(renglon[1] as! String)
            
            sql_insert += "'\(renglon[1] as! String)'"
            
            i += 1
            
            if i < resultado_nombre_columnas.count {
                
                sql_insert += ","
            }
            
        }
        
        sql_insert += ") values "
        
        //print("la cuenta de datos es \(datos.arreglo.count)")
        
        for k in 0 ..< datos.count
        {
            
            
            var valores:[AnyObject]=[]
            
            for columna in columnas {
                
                //print(columna)
                
                if datos[k][columna] != nil {
                    
                    
                    
                    valores.append("\(datos[k][columna]!)" as AnyObject)
                }
                else{
                    
                    valores.append("" as AnyObject)
                }
                
                
            }
            
            //print(columnas)
            //print(valores)
            
            sql_insert += "('"
            
            var q = 0
            
            for valor in valores {
                
                
                
                sql_insert += "\(valor.replacingOccurrences(of: "'", with: "''"))'"
                
                q += 1
                
                if q < valores.count {
                    
                    sql_insert += ",'"
                    
                }
                else{
                    
                    sql_insert += ")"
                    
                }
                
            }
            
            valores.removeAll()
            if (k+1) < datos.count {
                
                sql_insert += ","
            }
            
        }
        
        //print(sql_insert)
        
        let resultado_insert = execute_query(sql_insert)
        
        return resultado_insert
        
    }
    
    //fin insert bulk
    
    //insert sync
    /*
     func insert_sync(_ tabla:String,datos:JSON)->(Bool,String){
     
     var ids_borrar:[String]=[]
     var datos_insertar:[JSON]=[]
     
     for k in 0 ..< datos.arreglo.count {
     
     let active = datos.arreglo[k]["active"] as! String
     
     print(active)
     
     switch active {
     
     case "true":
     
     datos_insertar.append(datos[k])
     
     //_ = db.execute_query("delete from sku_sku where id = '\(id)'")
     
     //sql = "insert into sku_sku (id,id_brand,id_category,id_subcategory,id_manufacturer,value,clave) values ('\(id)','\(id_marca)','\(id_categoria)','\(id_subcategoria)','\(id_fabricante)','\(value)','\(clave)')"
     
     default:
     
     ids_borrar.append("\(datos.arreglo[k]["id"])")
     
     break
     }
     
     
     
     }
     
     print("los datos a insertar son \(datos_insertar)")
     
     let aux_datos = JSON(cadena:datos_insertar)
     
     
     
     
     let resultado_insert = insert_bulk(tabla, datos: aux_datos)
     
     return resultado_insert
     }
     */
    //fin insert sync
    
    func select_query_columns (_ sql:String) -> [[String:AnyObject]]{
        
        var data:[[String:AnyObject]] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        
        var i = 0
        
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            //let id = sqlite3_column_int64(statement, 0)
            //print("id = \(id); ")
            
            let k = sqlite3_column_count(statement)
            
            var q = 0 as Int32
            
            data.append([String:AnyObject]())
            
            repeat {
                
                
                
                //print(i)
                
                let tipo = sqlite3_column_type(statement, q)
                
                
                
                let aux_nombre = sqlite3_column_name(statement, q)
                
                //let nombre = String.fromCString(aux_nombre!)!
                let nombre = String(cString:aux_nombre!)
                
                
                
                
                
                
                
                //print("tipo \(tipo)")
                //
                
                if (tipo == 1){
                    let column = sqlite3_column_int(statement, q)
                    //print("valor \(column)")
                    
                    //data[i].append(Int(column))
                    data[i][nombre] = Int(column) as AnyObject?
                    
                }
                
                if (tipo == 2){
                    let column = sqlite3_column_double(statement, q) as Double
                    //print("valor \(column)")
                    //data[i].append(Double(column))
                    data[i][nombre] = Double(column) as AnyObject?
                    
                }
                
                if (tipo == 3){
                    let column = sqlite3_column_text(statement, q)
                    
                    if column != nil {
                        
                        
                        //let nameString = String.fromCString(UnsafePointer<Int8>(column!))
                        let nameString = String(cString:column!)
                        
                        
                        //data[i].append(nameString!)
                        data[i][nombre] = nameString as AnyObject?
                        
                        //print("column = \(nameString!)")
                    }
                    else {
                        print("column not found")
                    }
                    
                }
                
                /*if (tipo == 4){
                 let column = sqlite3_column_blob(statement, q)
                 print("valor \(column)")
                 data[i][Int(q)] = column as String
                 
                 }
                 */
                
                
                
                q += 1
                
            } while q < k
            
            i += 1
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        return data
    }
    
    
    
    //query colums strings
    
    
    func select_query_columns_string (_ sql:String) -> [[String:String]]{
        
        var data:[[String:String]] = []
        
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        
        var i = 0
        
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            //let id = sqlite3_column_int64(statement, 0)
            //print("id = \(id); ")
            
            let k = sqlite3_column_count(statement)
            
            var q = 0 as Int32
            
            data.append([String:String]())
            
            repeat {
                
                
                
                //print(i)
                
                let tipo = sqlite3_column_type(statement, q)
                
                
                
                let aux_nombre = sqlite3_column_name(statement, q)
                
                //let nombre = String.fromCString(aux_nombre!)!
                
                var nombre = "aux"
                
                if aux_nombre != nil {
                    
                    nombre = String(cString:aux_nombre!)
                }
                
                
                
                
                
                
                
                //print("tipo \(tipo)")
                //
                
                if (tipo == 1){
                    let column = sqlite3_column_int(statement, q)
                    //print("valor \(column)")
                    
                    //data[i].append(Int(column))
                    let auxDato = Int(column)
                    
                    data[i][nombre] = "\(auxDato)"
                    
                }
                
                if (tipo == 2){
                    let column = sqlite3_column_double(statement, q) as Double
                    //print("valor \(column)")
                    //data[i].append(Double(column))
                    let auxDato = Double(column)
                    
                    data[i][nombre] = "\(auxDato)"
                    
                }
                
                if (tipo == 3){
                    let column = sqlite3_column_text(statement, q)
                    
                    if column != nil {
                        
                        
                        //let nameString = String.fromCString(UnsafePointer<Int8>(column!))
                        let nameString = String(cString:column!)
                        
                        
                        //data[i].append(nameString!)
                        data[i][nombre] = nameString as String
                        
                        //print("column = \(nameString!)")
                    }
                    else {
                        print("column not found")
                    }
                    
                }
                
                /*if (tipo == 4){
                 let column = sqlite3_column_blob(statement, q)
                 print("valor \(column)")
                 data[i][Int(q)] = column as String
                 
                 }
                 */
                
                
                
                q += 1
                
            } while q < k
            
            i += 1
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        return data
    }
    
    
    
    
    //fin query colums strings
    
    
    
    
    func select_query( _ sql:String?) -> [[AnyObject]]{
        
        
        
        var data:[[AnyObject]] = []
        
        if sqlite3_prepare_v2(db, sql!, -1, &statement, nil) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error preparing select: \(errmsg)")
        }
        
        var i = 0
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            //let id = sqlite3_column_int64(statement, 0)
            //print("id = \(id); ")
            
            let k = sqlite3_column_count(statement)
            
            var q = 0 as Int32
            
            data.append([AnyObject]())
            
            repeat {
                
                
                
                //print(i)
                
                let tipo = sqlite3_column_type(statement, q)
                
                
                
                //print("tipo \(tipo)")
                //
                
                if (tipo == 1){
                    let column = sqlite3_column_int(statement, q)
                    //print("valor \(column)")
                    
                    data[i].append(Int(column) as AnyObject)
                    
                }
                
                if (tipo == 2){
                    let column = sqlite3_column_double(statement, q) as Double
                    //print("valor \(column)")
                    data[i].append(Double(column) as AnyObject)
                    
                }
                
                if (tipo == 3){
                    let column = sqlite3_column_text(statement, q)
                    
                    if column != nil {
                        
                        
                        //let nameString = String.fromCString(UnsafePointer<Int8>(column))
                        let nameString = String(cString: column!)
                        
                        
                        data[i].append(nameString as AnyObject)
                        
                        //print("column = \(nameString!)")
                    }
                    else {
                        print("column not found")
                    }
                    
                }
                
                /*if (tipo == 4){
                 let column = sqlite3_column_blob(statement, q)
                 print("valor \(column)")
                 data[i][Int(q)] = column as String
                 
                 }
                 */
                
                
                
                q += 1
                
            } while q < k
            
            i += 1
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            //let errmsg = String.fromCString(sqlite3_errmsg(db))
            let errmsg = String(cString:sqlite3_errmsg(db))
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        return data
    }
    
}

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
        
        get {
            
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
        
        get {
            
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
        
        get {
            
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
        
        get {
            
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        
        let nsSt = self as NSString
        
        return nsSt.appendingPathExtension(ext)
    }
}
