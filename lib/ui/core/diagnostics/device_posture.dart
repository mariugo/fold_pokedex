/// The physical fold state of a foldable device's display.
enum DevicePosture {
  /// The device is fully unfolded, i.e. flat.
  flat,

  /// The device is partially folded, exposing a hinge or folding region.
  halfOpened,

  /// The posture could not be determined on this platform or device.
  unknown,
}
