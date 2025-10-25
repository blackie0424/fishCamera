# GitHub 倉庫設置指南

## 步驟 1：在 GitHub 上建立新倉庫

1. 前往 [GitHub](https://github.com)
2. 點擊右上角的 "+" 按鈕，選擇 "New repository"
3. 填寫倉庫資訊：
   - **Repository name**: `camera-measurement-app` 或你喜歡的名稱
   - **Description**: `iOS AR 相機測量應用程式 - 使用 ARKit 測量物體尺寸並提供直觀對比物`
   - **Visibility**: Public 或 Private（依你的需求）
   - **不要勾選** "Add a README file"（因為我們已經有了）
   - **不要勾選** "Add .gitignore"（我們會自己處理）
   - **不要勾選** "Choose a license"（可以之後再加）

## 步驟 2：連接本地倉庫到 GitHub

建立倉庫後，GitHub 會提供 URL，格式類似：

- HTTPS: `https://github.com/你的用戶名/camera-measurement-app.git`
- SSH: `git@github.com:你的用戶名/camera-measurement-app.git`

## 步驟 3：執行以下指令

```bash
# 添加遠端倉庫（請替換成你的實際 URL）
git remote add origin https://github.com/你的用戶名/camera-measurement-app.git

# 推送 main 分支
git push -u origin main

# 推送 develop 分支（目前的開發分支）
git push -u origin develop

# 設定 develop 為預設分支（可選）
git branch --set-upstream-to=origin/develop develop
```

## 步驟 4：驗證推送成功

```bash
# 檢查遠端設定
git remote -v

# 檢查分支狀態
git branch -a

# 查看最新狀態
git status
```

## 目前專案狀態

✅ **已完成的提交**：

- `86df34f` - 初始專案設定（需求、設計、任務文件）
- `0deacf7` - 更新任務 1 完成狀態
- `0b46f10` - 建立 iOS 專案核心結構
- `639ecf3` - 建立專案模組化目錄結構
- `f880fbb` - 添加 UI 資源和本地化支援
- `f3a0c94` - 添加專案說明文件

📋 **分支結構**：

- `main` - 穩定版本分支
- `develop` - 開發分支（目前位置）

🚀 **準備推送**：所有提交都已準備好推送到 GitHub
