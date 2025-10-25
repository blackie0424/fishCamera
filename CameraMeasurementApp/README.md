# Camera Measurement App

一個使用 ARKit 進行物體測量的 iOS 應用程式。

## 專案結構

```
CameraMeasurementApp/
├── CameraMeasurementApp/
│   ├── Models/                     # 數據模型
│   │   └── DeviceCapability.swift  # 設備能力檢測
│   ├── Services/                   # 服務層
│   │   └── ARMeasurementEngineDelegate.swift  # AR 測量引擎委託
│   ├── ViewControllers/            # 視圖控制器
│   │   ├── CameraViewController.swift         # 主相機控制器
│   │   └── CameraViewControllerDelegate.swift # 相機控制器委託
│   ├── Extensions/                 # 擴展 (待實現)
│   ├── AppDelegate.swift          # 應用程式委託
│   ├── SceneDelegate.swift        # 場景委託
│   ├── Info.plist                 # 應用程式配置
│   ├── Assets.xcassets/           # 資源文件
│   └── Base.lproj/                # 本地化資源
│       ├── Main.storyboard        # 主故事板
│       └── LaunchScreen.storyboard # 啟動畫面
└── CameraMeasurementApp.xcodeproj/ # Xcode 專案文件
```

## 核心功能

### 已實現

- ✅ iOS 專案結構設置
- ✅ ARKit 權限配置
- ✅ 核心協議定義 (ARMeasurementEngineDelegate, CameraViewControllerDelegate)
- ✅ 基礎相機視圖控制器
- ✅ 設備能力檢測模型
- ✅ AR 會話管理

### 待實現

- ⏳ 物體檢測和測量算法
- ⏳ 對比物系統
- ⏳ 測量結果顯示
- ⏳ 數據持久化
- ⏳ 錯誤處理系統

## 系統要求

- iOS 12.0+
- iPhone 8 或更新版本
- ARKit 支援
- 相機權限

## 核心協議

### ARMeasurementEngineDelegate

負責處理測量過程中的各種事件：

- 測量完成回調
- 測量失敗處理
- 精度警告
- 進度更新

### CameraViewControllerDelegate

負責處理相機相關的用戶交互：

- 拍攝按鈕點擊
- 測量結果捕獲
- 錯誤處理
- AR 會話狀態變化

## 設備能力檢測

應用程式會自動檢測設備能力：

- ARKit 支援檢查
- LiDAR 感應器檢測
- 場景重建能力
- 物體檢測支援

根據設備能力自動調整測量策略，確保在不同 iPhone 型號上都能正常運作。
