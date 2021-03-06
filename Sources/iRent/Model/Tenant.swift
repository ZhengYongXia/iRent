//
//  Tenant.swift
//  iRentPackageDescription
//
//  Created by nil on 2018/3/3.
//

import Foundation
import StORM
import MySQLStORM
import SwiftMoment

class Tenant: MySQLStORM {
    
    var id: Int                         = 0
    var room_id: Int                    = 0                     //房间id
    var state: Int                      = 0                     //是否退房
    var name: String                    = ""                    //姓名
    var idcard: String                  = ""                    //身份证号码
    var phone: String                   = ""                    //手机号
    var create_at: Date                 = moment().date         //创建时间
    var updated_at: Date                = moment().date         //更新时间
    
    override func table() -> String {
        return "Tenant"
    }
    
    override func to(_ this: StORMRow) {
        id              = Int(this.data["id"]           as? Int32       ?? 0)
        room_id         = Int(this.data["room_id"]      as? Int32       ?? 0)
        state           = Int(this.data["state"]        as? Int32       ?? 0)
        name            = this.data["name"]             as? String      ?? ""
        idcard          = this.data["idcard"]           as? String      ?? ""
        phone           = this.data["phone"]            as? String      ?? ""
        create_at       = this.data["create_at"]        as? Date        ?? moment().date
        updated_at      = this.data["updated_at"]       as? Date        ?? moment().date
    }
    
    func rows() -> [Tenant] {
        var rows = [Tenant]()
        for i in 0..<self.results.rows.count {
            let row = Tenant()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
