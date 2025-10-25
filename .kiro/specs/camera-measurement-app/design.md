# 設計文件

## 概述

Camera Measurement App 是一個 iOS 應用程式，利用 ARKit 和相機技術來測量物體尺寸，並提供直觀的對比物來幫助用戶理解物體大小。應用程式支援 iPhone 8 及以上版本，優先使用 LiDAR 感應器（如果可用）來提高測量精度。

### 核心功能

- 即時相機預覽和物體檢測
- AR 測量引擎進行尺寸計算
- 智能對比物選擇和顯示
- 測量結果保存和歷史記錄

## 架構

### 系統架構圖

```
┌─────────────────────────────────────────────────────────────┐
│                    Camera Measurement App                    │
├─────────────────────────────────────────────────────────────┤
│  UI Layer                                                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │  Camera View    │  │ Measurement     │  │  History    │ │
│  │  Controller     │  │ Display         │  │  View       │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  Business Logic Layer                                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ AR Measurement  │  │ Comparison      │  │ Data        │ │
│  │ Engine          │  │ Object System   │  │ Manager     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  Core Services Layer                                        │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ Object          │  │ Size            │  │ Storage     │ │
│  │ Detection       │  │ Calibration     │  │ Service     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  Platform Layer                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │ ARKit           │  │ Camera          │  │ Core Data   │ │
│  │ Framework       │  │ Framework       │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 設計決策理由

- **分層架構**: 採用分層架構確保關注點分離，便於維護和測試
- **ARKit 整合**: 使用 ARKit 作為核心 AR 功能提供者，支援平面檢測和 LiDAR
- **模組化設計**: 將測量引擎、對比物系統和數據管理分離為獨立模組

## 組件和介面

### 1. Camera View Controller

**職責**: 管理相機預覽、用戶交互和 AR 會話

```swift
protocol CameraViewControllerDelegate {
    func didCaptureMeasurement(_ measurement: MeasurementResult)
    func didFailWithError(_ error: MeasurementError)
}

class CameraViewController: UIViewController {
    // AR 會話管理
    private var arSession: ARSession
    private var sceneView: ARSCNView

    // UI 組件
    private var captureButton: UIButton
    private var progressIndicator: UIActivityIndicatorView

    // 核心功能
    func startARSession()
    func captureAndMeasure()
    func displayMeasurementResult(_ result: MeasurementResult)
}
```

### 2. AR Measurement Engine

**職責**: 執行物體檢測和尺寸測量

```swift
protocol ARMeasurementEngineDelegate {
    func measurementDidComplete(_ result: MeasurementResult)
    func measurementDidFail(with error: MeasurementError)
    func measurementAccuracyWarning(_ accuracy: Float)
}

class ARMeasurementEngine {
    private var objectDetection: ObjectDetection
    private var sizeCalibration: SizeCalibration

    func measureObject(from frame: ARFrame) -> MeasurementResult
    func validateMeasurementAccuracy(_ result: MeasurementResult) -> Float
    func requiresLightingImprovement() -> Bool
}
```

### 3. Comparison Object System

**職責**: 選擇和顯示適當的對比物

```swift
enum ComparisonObjectType {
    case coin        // 50元硬幣 (直徑 2.8cm)
    case lighter     // 打火機 (長度 8cm)
    case phone       // 手機 (長度 15cm)
    case bottle      // 瓶子 (高度 25cm)
    case book        // 書本 (長度 21cm)
}

class ComparisonObjectSystem {
    func selectComparisonObject(for size: CGSize) -> ComparisonObjectType
    func create3DModel(for objectType: ComparisonObjectType) -> SCNNode
    func positionComparisonObject(_ node: SCNNode, relativeTo target: SCNNode)
}
```

### 4. Measurement Display

**職責**: 顯示測量數值和視覺指示器

```swift
class MeasurementDisplay {
    func displayMeasurements(_ measurements: [String: Float], at position: SCNVector3)
    func updateDisplayPosition(for cameraTransform: simd_float4x4)
    func formatMeasurementText(_ value: Float) -> String
}
```

## 數據模型

### MeasurementResult

```swift
struct MeasurementResult {
    let id: UUID
    let timestamp: Date
    let dimensions: Dimensions
    let accuracy: Float
    let comparisonObject: ComparisonObjectType
    let image: UIImage
    let notes: String?

    struct Dimensions {
        let length: Float  // 公分
        let width: Float   // 公分
        let height: Float  // 公分
    }
}
```

### MeasurementError

```swift
enum MeasurementError: Error {
    case insufficientLighting
    case objectNotDetected
    case lowAccuracy(Float)
    case arSessionFailed
    case unsupportedDevice
}
```

### DeviceCapability

```swift
struct DeviceCapability {
    let hasLiDAR: Bool
    let supportsARKit: Bool
    let modelName: String

    static func current() -> DeviceCapability
}
```

## 錯誤處理

### 錯誤處理策略

1. **設備兼容性檢查**: 啟動時驗證 iPhone 8+ 和 ARKit 支援
2. **光線條件監控**: 持續監控環境光線，不足時提示用戶
3. **測量精度驗證**: 精度低於 90% 時顯示警告並建議重新測量
4. **優雅降級**: LiDAR 不可用時自動切換到 ARKit 平面檢測

### 用戶反饋機制

```swift
class ErrorHandler {
    func handleMeasurementError(_ error: MeasurementError) {
        switch error {
        case .insufficientLighting:
            showAlert("請在光線充足的環境下進行測量")
        case .objectNotDetected:
            showAlert("無法識別物體，請調整拍攝角度")
        case .lowAccuracy(let accuracy):
            showAlert("測量精度較低 (\(accuracy)%)，建議重新測量")
        case .arSessionFailed:
            showAlert("AR 功能啟動失敗，請重新啟動應用程式")
        case .unsupportedDevice:
            showAlert("此設備不支援測量功能，需要 iPhone 8 或更新版本")
        }
    }
}
```

## 測試策略

### 單元測試

- **ARMeasurementEngine**: 測量算法準確性
- **ComparisonObjectSystem**: 對比物選擇邏輯
- **MeasurementDisplay**: 數值格式化和顯示邏輯
- **DataManager**: 數據持久化功能

### 整合測試

- **AR 會話整合**: ARKit 與測量引擎的協作
- **UI 流程測試**: 從拍攝到結果顯示的完整流程
- **設備兼容性**: 不同 iPhone 型號的功能驗證

### 性能測試

- **測量響應時間**: 確保測量過程在 3 秒內完成
- **記憶體使用**: 監控 AR 會話和 3D 模型的記憶體消耗
- **電池消耗**: 長時間使用的電池影響評估

### 用戶驗收測試

- **測量準確性**: 使用已知尺寸物體驗證測量精度
- **對比物適用性**: 驗證對比物選擇的直觀性
- **用戶體驗**: 整體操作流程的易用性評估

### 設備測試矩陣

| 設備型號    | ARKit 支援 | LiDAR | 測試重點         |
| ----------- | ---------- | ----- | ---------------- |
| iPhone 8/8+ | ✓          | ✗     | 基礎 AR 測量功能 |
| iPhone X/XS | ✓          | ✗     | 面部識別整合     |
| iPhone 11   | ✓          | ✗     | 改進的 AR 性能   |
| iPhone 12+  | ✓          | ✓     | LiDAR 增強測量   |

### 測試自動化

- 使用 XCTest 框架進行單元和整合測試
- UI 測試使用 XCUITest 自動化用戶交互
- 持續整合管道確保每次提交的代碼品質
