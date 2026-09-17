import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Unverified: no Mac/Xcode available to confirm `messenger()` resolves
    // as expected on this newer implicit-engine embedding. See
    // FoldPostureStreamHandler.swift for details.
    let postureChannel = FlutterEventChannel(
      name: "fold_pokedex/fold_posture",
      binaryMessenger: engineBridge.pluginRegistry.messenger()
    )
    postureChannel.setStreamHandler(FoldPostureStreamHandler())
  }
}
