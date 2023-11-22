class DeviceInfo {
  final String model;
  final String deviceId;

  DeviceInfo({required this.model, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'deviceId': deviceId,
    };
  }
}
