import Flutter
import UIKit

/// Streams fold posture updates to Dart over the `fold_pokedex/fold_posture`
/// event channel.
///
/// This has not been built or run — there is no Mac/Xcode in the authoring
/// workspace to verify it against the iOS 27 SDK. `currentPosture()` is a
/// placeholder: iPhone Duo does not appear to expose a simple "flat" vs.
/// "half-opened" query the way Android's `androidx.window` does. Apple's own
/// guidance for iPhone Duo instead points apps toward reacting to size class
/// and `reservedRegion` changes (see "Designing for iPhone Duo" on
/// developer.apple.com) rather than querying raw device pose. Replace the
/// body of `currentPosture()` with the real signal once verified against the
/// actual SDK headers on a Mac.
final class FoldPostureStreamHandler: NSObject, FlutterStreamHandler {
  private var eventSink: FlutterEventSink?
  private var orientationObservation: NSObjectProtocol?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    events(currentPosture())

    orientationObservation = NotificationCenter.default.addObserver(
      forName: UIDevice.orientationDidChangeNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self, let sink = self.eventSink else { return }
      sink(self.currentPosture())
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    if let orientationObservation {
      NotificationCenter.default.removeObserver(orientationObservation)
    }
    orientationObservation = nil
    eventSink = nil
    return nil
  }

  /// Returns `"flat"`, `"halfOpened"`, or `"unknown"`.
  ///
  /// TODO: Replace with the real iPhone Duo posture/reserved-region signal
  /// once verified against the iOS 27 SDK on a Mac. Always reports
  /// `"unknown"` today because there is no confirmed public API to query
  /// fold state directly.
  private func currentPosture() -> String {
    return "unknown"
  }
}
