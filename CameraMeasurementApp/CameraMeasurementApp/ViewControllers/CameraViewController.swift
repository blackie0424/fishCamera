import UIKit
import ARKit
import SceneKit

/// 主要的相機視圖控制器
/// 負責管理 AR 會話、用戶界面和測量流程
class CameraViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 委託對象，處理相機相關事件
    weak var delegate: CameraViewControllerDelegate?
    
    /// AR 場景視圖
    private var sceneView: ARSCNView!
    
    /// AR 會話
    private var arSession: ARSession!
    
    /// 拍攝按鈕
    private var captureButton: UIButton!
    
    /// 進度指示器
    private var progressIndicator: UIActivityIndicatorView!
    
    /// 狀態標籤
    private var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupARSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseARSession()
    }
    
    // MARK: - Setup Methods
    
    /// 設置用戶界面
    private func setupUI() {
        view.backgroundColor = .black
        
        // 設置 AR 場景視圖
        sceneView = ARSCNView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sceneView)
        
        // 設置拍攝按鈕
        captureButton = UIButton(type: .system)
        captureButton.setTitle("拍攝測量", for: .normal)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.backgroundColor = UIColor.systemBlue
        captureButton.layer.cornerRadius = 30
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        view.addSubview(captureButton)
        
        // 設置進度指示器
        progressIndicator = UIActivityIndicatorView(style: .large)
        progressIndicator.color = .white
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.hidesWhenStopped = true
        view.addSubview(progressIndicator)
        
        // 設置狀態標籤
        statusLabel = UILabel()
        statusLabel.text = "將相機對準要測量的物體"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // 設置約束
        setupConstraints()
    }
    
    /// 設置自動佈局約束
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // AR 場景視圖約束
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 拍攝按鈕約束
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.widthAnchor.constraint(equalToConstant: 120),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            
            // 進度指示器約束
            progressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // 狀態標籤約束
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    /// 設置 AR 會話
    private func setupARSession() {
        arSession = ARSession()
        sceneView.session = arSession
        sceneView.delegate = self
    }
    
    // MARK: - AR Session Management
    
    /// 啟動 AR 會話
    func startARSession() {
        guard ARWorldTrackingConfiguration.isSupported else {
            delegate?.didFailWithError(.unsupportedDevice)
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        
        // 如果支援 LiDAR，啟用場景重建
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        }
        
        arSession.run(configuration)
        delegate?.arSessionStateChanged(isActive: true)
        
        updateStatusLabel("AR 會話已啟動")
    }
    
    /// 暫停 AR 會話
    func pauseARSession() {
        arSession.pause()
        delegate?.arSessionStateChanged(isActive: false)
    }
    
    // MARK: - User Interaction
    
    /// 拍攝按鈕點擊事件
    @objc private func captureButtonTapped() {
        delegate?.didTapCaptureButton()
        captureAndMeasure()
    }
    
    /// 執行拍攝和測量
    func captureAndMeasure() {
        // 顯示進度指示器
        progressIndicator.startAnimating()
        captureButton.isEnabled = false
        updateStatusLabel("正在測量物體...")
        
        // 這裡將在後續任務中實現實際的測量邏輯
        // 目前只是模擬測量過程
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.progressIndicator.stopAnimating()
            self.captureButton.isEnabled = true
            self.updateStatusLabel("測量完成")
            
            // 模擬測量結果
            let mockResult = MeasurementResult(
                id: UUID(),
                timestamp: Date(),
                dimensions: MeasurementResult.Dimensions(length: 10.5, width: 8.2, height: 15.3),
                accuracy: 0.92,
                comparisonObject: .phone,
                image: nil,
                notes: nil
            )
            
            self.delegate?.didCaptureMeasurement(mockResult)
        }
    }
    
    /// 顯示測量結果
    func displayMeasurementResult(_ result: MeasurementResult) {
        let message = """
        測量結果:
        長度: \(result.dimensions.length) 公分
        寬度: \(result.dimensions.width) 公分
        高度: \(result.dimensions.height) 公分
        精度: \(Int(result.accuracy * 100))%
        """
        
        updateStatusLabel(message)
    }
    
    // MARK: - Helper Methods
    
    /// 更新狀態標籤文字
    private func updateStatusLabel(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = text
        }
    }
}

// MARK: - ARSCNViewDelegate

extension CameraViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        delegate?.didFailWithError(.arSessionFailed)
        updateStatusLabel("AR 會話錯誤: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        delegate?.arSessionStateChanged(isActive: false)
        updateStatusLabel("AR 會話被中斷")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        delegate?.arSessionStateChanged(isActive: true)
        updateStatusLabel("AR 會話已恢復")
    }
}