import Foundation
import UIKit

/// 測量結果結構體
struct MeasurementResult {
    let id: UUID
    let timestamp: Date
    let dimensions: Dimensions
    let accuracy: Float
    let comparisonObject: ComparisonObjectType
    let image: UIImage?
    let notes: String?
    
    struct Dimensions {
        let length: Float  // 公分
        let width: Float   // 公分  
        let height: Float  // 公分
    }
}

/// 測量錯誤類型
enum MeasurementError: Error {
    case insufficientLighting
    case objectNotDetected
    case lowAccuracy(Float)
    case arSessionFailed
    case unsupportedDevice
}

/// 對比物類型
enum ComparisonObjectType {
    case coin        // 50元硬幣 (直徑 2.8cm)
    case lighter     // 打火機 (長度 8cm)
    case phone       // 手機 (長度 15cm)
    case bottle      // 瓶子 (高度 25cm)
    case book        // 書本 (長度 21cm)
}

/// AR 測量引擎委託協議
/// 負責處理測量過程中的各種事件和狀態變化
protocol ARMeasurementEngineDelegate: AnyObject {
    
    /// 測量完成時調用
    /// - Parameter result: 測量結果，包含尺寸、精度等資訊
    func measurementDidComplete(_ result: MeasurementResult)
    
    /// 測量失敗時調用
    /// - Parameter error: 測量失敗的錯誤類型
    func measurementDidFail(with error: MeasurementError)
    
    /// 測量精度警告
    /// - Parameter accuracy: 當前測量精度百分比
    func measurementAccuracyWarning(_ accuracy: Float)
    
    /// 測量進度更新
    /// - Parameter progress: 測量進度 (0.0 - 1.0)
    func measurementProgressUpdated(_ progress: Float)
}