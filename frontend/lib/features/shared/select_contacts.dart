import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectContacts extends StatelessWidget {
  const SelectContacts({super.key});

  @override
  Widget build(BuildContext context) {
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
              ),
              SocialMediaSection(
                name: 'Phone',
                icon: FontAwesomeIcons.phone,
                color: Colors.blueAccent,
                keyboardType: TextInputType.phone,
              ),
              SocialMediaSection(
                name: 'WhatsApp',
                icon: FontAwesomeIcons.whatsapp,
                color: Colors.green,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {},
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

class SocialMediaSection extends StatefulWidget {
  final String name;
  final FaIconData icon;
  final Color color;
  final TextInputType keyboardType;

  const SocialMediaSection({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.keyboardType,
  });

  @override
  State<SocialMediaSection> createState() => _SocialMediaSectionState();
}

class _SocialMediaSectionState extends State<SocialMediaSection> {
  final TextEditingController _controller = TextEditingController();
  bool _isSwitched = true;

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextInputType keyboardType = widget.keyboardType;
    return Column(
      children: [
        ListTile(
          leading: FaIcon(widget.icon, color: widget.color),
          title: Text(widget.name),
          trailing: Switch(
            value: _isSwitched,
            onChanged: (value) {
              setState(() {
                _isSwitched = value;
              });
            },
            activeTrackColor: theme.colorScheme.primary,
            activeThumbColor: Colors.white,
          ),
        ),
        TextField(
          controller: _controller,
          enabled: _isSwitched,
          decoration: InputDecoration(
            labelText: keyboardType == TextInputType.phone
                ? 'Veuillez saisir votre numéro'
                : 'Veuillez saisir votre email',
            border: const OutlineInputBorder(),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
