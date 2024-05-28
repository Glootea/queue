import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:queue/data/encryprion.dart';
import 'package:queue/entities/export.dart';

class QrCodeDialog extends StatelessWidget {
  final QueueRecord queueRecord;
  const QrCodeDialog(this.queueRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    log(Platform.operatingSystem);

    return LimitedBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text("Загрузка данных без интернета"),
        content: Column(
          children: [
            const Text("Попроси друга отсканировать QR-код чтобы загрузить данные: "),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: PrettyQrView.data(
                      data: Encryption.encryct('lorem ipsum dolor sit amet'),
                      decoration: const PrettyQrDecoration(background: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            (kIsWeb)
                ? Container()
                : switch (Platform.operatingSystem) {
                    "android" => Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Или поделись ссылкой через LocalShare: ",
                              maxLines: null,
                            ),
                          ),
                          TextButton(onPressed: () {}, child: const Text("Поделиться"))
                        ],
                      ),
                    "ios" || "macos" => Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Или поделись ссылкой через AirDrop: ",
                              maxLines: null,
                            ),
                          ),
                          TextButton(onPressed: () {}, child: const Text("Поделиться"))
                        ],
                      ),
                    _ => Container()
                  }
          ],
        ),
        actions: [TextButton(onPressed: () => context.maybePop(), child: const Text("Закрыть"))],
      ),
    );
  }
}