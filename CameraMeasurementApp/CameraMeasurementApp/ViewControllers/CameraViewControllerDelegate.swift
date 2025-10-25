import Foundation
import UIKit

/// 相機視圖控制器委託協議
/// 負責處理相機相關的用戶交互和事件
protocol CameraViewControllerDelegate: AnyObject {
    
    /// 用戶點擊拍攝按鈕時調用
    func didTapCaptureButton()
    
    /// 測量完成並捕獲結果時調用
    /// - Parameter measurement: 完整的測量結果
    func didCaptureMeasurement(_ measurement: MeasurementResult)
    
    /// 測量過程中發生錯誤時調用
    /// - Parameter error: 錯誤類型和詳細資訊
    func didFailWithError(_ error: MeasurementError)
    
    /// AR 會話狀態變化時調用
    /// - Parameter isActive: AR 會話是否處於活躍狀態
    func arSessionStateChanged(isActive: Bool)
    
    /// 用戶請求保存測量結果時調用
    /// - Parameter measurement: 要保存的測量結果
    func didRequestSaveMeasurement(_ measurement: MeasurementResult)
    
    /// 用戶請求查看測量歷史時調用
    func didRequestViewHistory()
    
    /// 用戶請求校準功能時調用
    func didRequestCalibration()
}