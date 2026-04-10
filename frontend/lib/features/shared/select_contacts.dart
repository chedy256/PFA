import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfa/core/providers/user_data_provider.dart';

class SelectContacts extends ConsumerStatefulWidget {
  const SelectContacts({super.key});

  @override
  ConsumerState<SelectContacts> createState() => _SelectContactsState();
}

class _SelectContactsState extends ConsumerState<SelectContacts> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _wsPhoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _phoneEnabled = true;
  bool _wsPhoneEnabled = true;
  bool _emailEnabled = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userData = ref.read(userDataProvider).value;
      if (userData != null) {
        _phoneController.text = userData.phone ?? '';
        _wsPhoneController.text = userData.wsPhone ?? '';
        _emailController.text = userData.email;
        _phoneEnabled = userData.phoneEnabled;
        _wsPhoneEnabled = userData.wsPhoneEnabled;
        _emailEnabled = userData.emailEnabled;
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _wsPhoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDataProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        final userData = next.value!;
        _phoneController.text = userData.phone ?? '';
        _wsPhoneController.text = userData.wsPhone ?? '';
        _emailController.text = userData.email;
        _phoneEnabled = userData.phoneEnabled;
        _wsPhoneEnabled = userData.wsPhoneEnabled;
        _emailEnabled = userData.emailEnabled;
        setState(() {});
      }
    });

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Select Contacts')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            spacing: 12,
            children: [
              SocialMediaSection(
                name: 'Email',
                icon: FontAwesomeIcons.envelope,
                color: Colors.grey,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                isSwitched: _emailEnabled,
                onChanged: (val) => setState(() => _emailEnabled = val),
              ),
              SocialMediaSection(
                name: 'Phone',
                icon: FontAwesomeIcons.phone,
                color: Colors.blueAccent,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                isSwitched: _phoneEnabled,
                onChanged: (val) => setState(() => _phoneEnabled = val),
              ),
              SocialMediaSection(
                name: 'WhatsApp',
                icon: FontAwesomeIcons.whatsapp,
                color: Colors.green,
                keyboardType: TextInputType.phone,
                controller: _wsPhoneController,
                isSwitched: _wsPhoneEnabled,
                onChanged: (val) => setState(() => _wsPhoneEnabled = val),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () async {
                  await ref.read(userDataProvider.notifier).updateContacts(
                        phone: _phoneController.text,
                        wsPhone: _wsPhoneController.text,
                        phoneEnabled: _phoneEnabled,
                        wsPhoneEnabled: _wsPhoneEnabled,
                        emailEnabled: _emailEnabled,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacts mis à jour !')),
                    );
                    Navigator.pop(context);
                  }
                },
                label: const Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 18),
                ),
                icon: const Icon(Icons.save_outlined, size: 22),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaSection extends StatelessWidget {
  final String name;
  final FaIconData icon;
  final Color color;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isSwitched;
  final ValueChanged<bool> onChanged;

  const SocialMediaSection({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.keyboardType,
    required this.controller,
    required this.isSwitched,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          leading: FaIcon(icon, color: color),
          title: Text(name),
          trailing: Switch(
            value: isSwitched,
            onChanged: onChanged,
            activeTrackColor: theme.colorScheme.primary,
            activeThumbColor: Colors.white,
          ),
        ),
        TextField(
          controller: controller,
          enabled: isSwitched,
          decoration: InputDecoration(
            labelText: keyboardType == TextInputType.phone
                ? 'Veuillez saisir votre numéro'
                : 'Veuillez saisir votre email',
            border: const OutlineInputBorder(),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black26),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
