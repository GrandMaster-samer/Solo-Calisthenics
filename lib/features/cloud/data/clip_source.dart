import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

import '../domain/cloud_backend.dart';

class ClipTooLongException implements Exception {
  const ClipTooLongException();
}

/// Gets a clip for coach review, ready to upload.
abstract interface class ClipSource {
  /// Records or picks a clip and returns it compressed (720p, no audio), or null if
  /// the user cancelled. Throws [ClipTooLongException] over [CloudLimits.maxClipSeconds].
  Future<File?> pick({required bool camera});
}

/// Uses the camera / gallery and the platform's hardware video encoder.
/// The compression package sits behind [ClipSource] so it can be replaced.
class DeviceClipSource implements ClipSource {
  @override
  Future<File?> pick({required bool camera}) async {
    final picked = await ImagePicker().pickVideo(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      maxDuration: const Duration(seconds: CloudLimits.maxClipSeconds),
    );
    if (picked == null) return null;
    final info = await VideoCompress.getMediaInfo(picked.path);
    final seconds = (info.duration ?? 0) / 1000;
    if (seconds > CloudLimits.maxClipSeconds + 0.5) {
      throw const ClipTooLongException();
    }
    final compressed = await VideoCompress.compressVideo(
      picked.path,
      quality: VideoQuality.Res1280x720Quality,
      includeAudio: false, // form review needs no sound, and it keeps bystanders' voices private
      deleteOrigin: false,
    );
    final path = compressed?.path;
    return path == null ? null : File(path);
  }
}
