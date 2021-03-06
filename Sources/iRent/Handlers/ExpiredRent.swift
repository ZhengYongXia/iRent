
import Foundation
import PerfectLib
import PerfectHTTP
import MySQLStORM
import StORM
import SwiftMoment


/// 抄表
public class ExpiredRent: BaseHandler {
    /// 抄表
    ///
    /// - Parameters:
    ///   - request: 请求
    ///   - response: 响应
    static func update() -> RequestHandler {
        return {
            request, response in
            do {
                guard
                    let json = request.postBodyString,
                    let dict = try json.jsonDecode() as? [String: Any]
                    else {
                        error(request, response, error: "请填写请求参数")
                        return
                }
                //id
                guard let id: Int = dict["id"] as? Int else {
                    error(request, response, error: "id 请求参数不正确")
                    return
                }
                //月份
                guard let month: String = dict["month"] as? String, moment(month, dateFormat: DateFormat.month) != nil else {
                    error(request, response, error: "月份 month 请求参数不正确")
                    return
                }
                //水表数
                guard let water: Int = dict["water"] as? Int else {
                    error(request, response, error: "水表数 water 请求参数不正确")
                    return
                }
                //电表数
                guard let electricity: Int = dict["electricity"] as? Int else {
                    error(request, response, error: "电表数 electricity 请求参数不正确")
                    return
                }
                
                let room = Room()
                try room.get(id)
                if room.rows().count == 0 {
                    error(request, response, error: "房间id不存在")
                    return
                }
                
                let payment = Payment()
                try payment.select(whereclause: "room_id = ? AND month = ?",
                                   params: [id, month],
                                   orderby: [])
                
                if payment.rows().count != 0,
                    payment.rows().count != 0 {
                    error(request, response, error: "已经更新过数据")
                    return
                }
                
                
                
                payment.room_id         = id
                payment.month           = month
                payment.water           = water
                payment.electricity     = electricity
                payment.state           = 0
                
                let payment_insert =  try payment.insert(
                    cols: ["room_id",
                           "state",
                           "month",
                           "water",
                           "electricity",
                           "create_at",
                           "updated_at"],
                    params: [payment.room_id,
                             payment.state,
                             payment.month,
                             payment.water,
                             payment.electricity,
                             payment.create_at,
                             payment.updated_at,]
                )
                
                try response.setBody(json: ["success": true, "status": 200, "data":
                    [
                        "payment_id": payment_insert,
                    ]])
                response.completed()
            } catch {
                serverErrorHandler(request, response)
                Log.error(message: "update : \(error)")
            }
        }
    }
    
}

