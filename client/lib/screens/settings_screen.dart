import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradfri_extension/toasts.dart';
import 'package:tradfri_extension/widgets/settings_row.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController serverUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fillFields();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onSave,
        child: const Icon(Icons.save),
      ),
      body: Center(
          child: Container(
              padding: const EdgeInsets.all(15),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Row(children: [
                        SettingsRow(
                            text: "Server URL", controller: serverUrlController)
                      ]),
                    ],
                  )))),
    );
  }

  /* ---------------------- OTHER METHODS --------------------- */

  void fillFields() {
    SharedPreferences.getInstance().then((prefs) {
      serverUrlController.text = prefs.getString('server_url') ?? '';
    });
  }

  void onSave() {
    final String serverUrl = serverUrlController.text;

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('server_url', serverUrl);

      successToast('Settings saved');
    });
  }
}
