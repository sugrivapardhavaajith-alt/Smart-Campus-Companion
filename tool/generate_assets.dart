import 'dart:io';
import 'dart:typed_data';

void main() {
  final dir = Directory('assets/images');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  // Create 3 PNGs: logo, student avatar, campus hero
  File('assets/images/campusly_logo.png').writeAsBytesSync(
    createGradientPng(128, 128, 0x4F, 0x46, 0xE5, 0x8B, 0x5C, 0xF6),
  );
  File('assets/images/student_avatar.png').writeAsBytesSync(
    createGradientPng(128, 128, 0x3B, 0x82, 0xF6, 0x1D, 0x4E, 0xD8),
  );
  File('assets/images/campus_banner.png').writeAsBytesSync(
    createGradientPng(400, 200, 0x31, 0x2E, 0x81, 0x4F, 0x46, 0xE5),
  );

  // ignore: avoid_print
  print('Successfully created asset images in assets/images/');
}

Uint8List createGradientPng(int width, int height, int r1, int g1, int b1, int r2, int g2, int b2) {
  // Construct raw RGBA bitmap with filter byte 0 at start of each scanline
  final rawData = BytesBuilder();
  for (int y = 0; y < height; y++) {
    rawData.addByte(0); // PNG Filter Type: None
    final t = y / height;
    final r = (r1 + (r2 - r1) * t).round().clamp(0, 255);
    final g = (g1 + (g2 - g1) * t).round().clamp(0, 255);
    final b = (b1 + (b2 - b1) * t).round().clamp(0, 255);
    for (int x = 0; x < width; x++) {
      rawData.addByte(r);
      rawData.addByte(g);
      rawData.addByte(b);
      rawData.addByte(255); // Alpha
    }
  }

  final compressed = zlib.encode(rawData.toBytes());

  final png = BytesBuilder();
  // PNG Signature
  png.add([137, 80, 78, 71, 13, 10, 26, 10]);

  // IHDR chunk
  final ihdrData = ByteData(13);
  ihdrData.setUint32(0, width);
  ihdrData.setUint32(4, height);
  ihdrData.setUint8(8, 8); // bit depth
  ihdrData.setUint8(9, 6); // color type 6: RGBA
  ihdrData.setUint8(10, 0); // compression method
  ihdrData.setUint8(11, 0); // filter method
  ihdrData.setUint8(12, 0); // interlace method
  writeChunk(png, 'IHDR', ihdrData.buffer.asUint8List());

  // IDAT chunk
  writeChunk(png, 'IDAT', Uint8List.fromList(compressed));

  // IEND chunk
  writeChunk(png, 'IEND', Uint8List(0));

  return png.toBytes();
}

void writeChunk(BytesBuilder builder, String type, Uint8List data) {
  final length = ByteData(4)..setUint32(0, data.length);
  builder.add(length.buffer.asUint8List());

  final typeBytes = Uint8List.fromList(type.codeUnits);
  builder.add(typeBytes);
  builder.add(data);

  final crc = calculateCrc32(typeBytes, data);
  final crcBytes = ByteData(4)..setUint32(0, crc);
  builder.add(crcBytes.buffer.asUint8List());
}

int calculateCrc32(Uint8List type, Uint8List data) {
  int crc = 0xFFFFFFFF;
  for (final b in type) {
    crc = _crcTable[(crc ^ b) & 0xFF] ^ (crc >>> 8);
  }
  for (final b in data) {
    crc = _crcTable[(crc ^ b) & 0xFF] ^ (crc >>> 8);
  }
  return crc ^ 0xFFFFFFFF;
}

final List<int> _crcTable = () {
  final table = List<int>.filled(256, 0);
  for (int n = 0; n < 256; n++) {
    int c = n;
    for (int k = 0; k < 8; k++) {
      if ((c & 1) != 0) {
        c = 0xEDB88320 ^ (c >>> 1);
      } else {
        c = c >>> 1;
      }
    }
    table[n] = c;
  }
  return table;
}();
