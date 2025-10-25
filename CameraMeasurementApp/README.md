# Camera Measurement App

iOS AR 相機測量應用程式 - 使用 ARKit 測量物體尺寸並提供直觀對比物

## 🚀 快速開始

### 方法 1：使用 Xcode 創建 iOS 專案（推薦）

1. **打開 Xcode**
2. **創建新專案**：

   - File → New → Project
   - 選擇 "iOS" → "App"
   - Product Name: `CameraMeasurementApp`
   - Bundle Identifier: `com.blackie0424.CameraMeasurementApp`
   - Language: Swift
   - Interface: Storyboard
   - 勾選 "Use Core Data"（可選）

3. **配置 ARKit 權限**：
   在 `Info.plist` 中添加：

   ```xml
   <key>NSCameraUsageDescription</key>
   <string>此應用程式需要使用相機來測量物體尺寸</string>
   <key>UIRequiredDeviceCapabilities</key>
   <array>
       <string>arkit</string>
   </array>
   ```

4. **添加 ARKit Framework**：
   - 選擇專案 → Target → General
   - 在 "Frameworks, Libraries, and Embedded Content" 中點擊 "+"
   - 添加 `ARKit.framework`

### 方法 2：目前的 Swift Package（用於測試）

```bash
# 編譯和運行基礎測試
swift run --package-path CameraMeasurementApp

# 或者
cd CameraMeasurementApp
swift run
```

## 📱 系統需求

- **iOS 13.0+**
- **iPhone 8 或更新版本**（支援 ARKit）
- **Xcode 15.0+**
- **Swift 5.9+**

## 🏗️ 專案架構

```
CameraMeasurementApp/
├── Models/              # 數據模型
│   ├── MeasurementResult.swift
│   ├── Dimensions.swift
│   └── DeviceCapability.swift
├── Services/            # 業務邏輯服務
│   ├── ARMeasurementEngine.swift
│   ├── ObjectDetection.swift
│   └── DataManager.swift
├── ViewControllers/     # UI 控制器
│   ├── CameraViewController.swift
│   └── HistoryViewController.swift
└── Resources/           # 資源文件
    ├── Assets.xcassets
    └── Storyboards/
```

## 🎯 核心功能

1. **AR 測量引擎**

   - 使用 ARKit 進行物體檢測
   - LiDAR 感應器支援（iPhone 12+）
   - 精度驗證和校準

2. **智能對比物系統**

   - 硬幣、打火機、手機等常見物品
   - 基於物體尺寸自動選擇
   - 3D 模型顯示

3. **測量結果管理**
   - 即時顯示測量數值
   - 保存測量歷史
   - 圖片和數據關聯

## 🔧 開發指南

### 下一步開發任務

參考 `tasks.md` 文件中的實作計劃：

1. ✅ **任務 1**: 設置專案結構和核心介面
2. 📋 **任務 2**: 實作數據模型和驗證
3. 📋 **任務 3**: 建立相機和 AR 會話管理
4. 📋 **任務 4**: 實作物體檢測和測量引擎

### 編譯和測試

```bash
# 使用 Xcode 編譯（推薦）
open CameraMeasurementApp.xcodeproj

# 或使用命令行（僅限 Swift Package 版本）
swift build --package-path CameraMeasurementApp
swift test --package-path CameraMeasurementApp
```

## 📋 當前狀態

- ✅ 專案基礎架構已建立
- ✅ Swift Package Manager 配置完成
- 🔄 準備轉換為完整的 iOS 專案
- 📋 等待實作核心 AR 功能

## 🤝 貢獻指南

1. 查看 `requirements.md` 了解功能需求
2. 參考 `design.md` 了解架構設計
3. 按照 `tasks.md` 中的任務順序開發
4. 每完成一個任務提交一次 commit

## 📄 授權

此專案為個人開發專案，請遵循相關開源協議。
