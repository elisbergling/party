import 'package:party/services/image_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final imageProvider = Provider<ImageService>((_) => ImageService());
