class CanvasController {
  void Function()? clearCallback;

  void clear() {
    clearCallback?.call();
  }
}