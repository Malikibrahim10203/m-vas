class Camera {
  String cameraPath;

  Camera({
    required this.cameraPath,
  });

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
    cameraPath: json["camera_path"],
  );

  Map<String, dynamic> toJson() => {
    "camera_path": cameraPath,
  };
}
