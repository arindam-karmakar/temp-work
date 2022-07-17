import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}

class OpenWebsite {
  final String initialUrl;
  final ChromeSafariBrowser browser = new MyBrowser();

  OpenWebsite({required this.initialUrl});

  Future open() async {
    browser.addMenuItem(
      ChromeSafariBrowserMenuItem(
        id: 1,
        label: "CDL Prep App",
        action: (url, title) {},
      ),
    );

    await browser.open(
      url: Uri.parse(initialUrl),
      options: ChromeSafariBrowserClassOptions(
        android: AndroidChromeCustomTabsOptions(addDefaultShareMenuItem: false),
        ios: IOSSafariOptions(barCollapsingEnabled: true),
      ),
    );
  }
}
