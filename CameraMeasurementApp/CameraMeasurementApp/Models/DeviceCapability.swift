import Foundation
import ARKit
import UIKit

/// 設備能力檢測結構體
/// 用於檢測當前設備支援的 AR 功能和硬體能力
struct DeviceCapability {
    
    /// 是否支援 LiDAR 感應器
    let hasLiDAR: Bool
    
    /// 是否支援 ARKit
    let supportsARKit: Bool
    
    /// 設備型號名稱
    let modelName: String
    
    /// 是否支援場景重建
    let supportsSceneReconstruction: Bool
    
    /// 是否支援物體檢測
    let supportsObjectDetection: Bool
    
    /// 初始化設備能力
    /// - Parameters:
    ///   - hasLiDAR: 是否有 LiDAR
    ///   - supportsARKit: 是否支援 ARKit
    ///   - modelName: 設備型號
    ///   - supportsSceneReconstruction: 是否支援場景重建
    ///   - supportsObjectDetection: 是否支援物體檢測
    init(hasLiDAR: Bool, supportsARKit: Bool, modelName: String, supportsSceneReconstruction: Bool, supportsObjectDetection: Bool) {
        self.hasLiDAR = hasLiDAR
        self.supportsARKit = supportsARKit
        self.modelName = modelName
        self.supportsSceneReconstruction = supportsSceneReconstruction
        self.supportsObjectDetection = supportsObjectDetection
    }
    
    /// 獲取當前設備的能力
    /// - Returns: 當前設備的 DeviceCapability 實例
    static func current() -> DeviceCapability {
        let modelName = UIDevice.current.model
        let supportsARKit = ARWorldTrackingConfiguration.isSupported
        let hasLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        let supportsSceneReconstruction = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        let supportsObjectDetection = ARObjectScanningConfiguration.isSupported
        
        return DeviceCapability(
            hasLiDAR: hasLiDAR,
            supportsARKit: supportsARKit,
            modelName: modelName,
            supportsSceneReconstruction: supportsSceneReconstruction,
            supportsObjectDetection: supportsObjectDetection
        )
    }
    
    /// 檢查設備是否符合最低要求
    /// - Returns: 是否符合應用程式的最低要求
    func meetsMinimumRequirements() -> Bool {
        return supportsARKit
    }
    
    /// 獲取設備能力描述
    /// - Returns: 設備能力的文字描述
    func getCapabilityDescription() -> String {
        var description = "設備型號: \(modelName)\n"
        description += "ARKit 支援: \(supportsARKit ? "是" : "否")\n"
        description += "LiDAR 感應器: \(hasLiDAR ? "是" : "否")\n"
        description += "場景重建: \(supportsSceneReconstruction ? "是" : "否")\n"
        description += "物體檢測: \(supportsObjectDetection ? "是" : "否")"
        return description
    }
    
    /// 獲取推薦的測量配置
    /// - Returns: 基於設備能力的推薦 AR 配置
    func getRecommendedConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        
        // 基本平面檢測
        configuration.planeDetection = [.horizontal, .vertical]
        
        // 如果支援場景重建，啟用網格重建
        if supportsSceneReconstruction {
            configuration.sceneReconstruction = .mesh
        }
        
        // 如果支援物體檢測，可以在後續版本中啟用
        // configuration.detectionObjects = referenceObjects
        
        return configuration
    }
}