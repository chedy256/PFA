import 'package:flutter/material.dart';
import 'package:pfa/core/theme/app_colors.dart';

class RequestDocumentPage extends StatefulWidget {
  const RequestDocumentPage({super.key});

  @override
  State<RequestDocumentPage> createState() => _RequestDocumentPageState();
}

class _RequestDocumentPageState extends State<RequestDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDocumentType;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController(
    text: '1',
  );

  final List<String> _documentTypes = [
    "Fiche d'informations de SFE/PFE",
    "Convention de stage",
    "Attestation de stage",
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Simulate API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande envoyée avec succès'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Demander un Document',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.appBarTheme.iconTheme?.color ?? theme.iconTheme.color,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              _buildSectionTitle('Type de document *', theme),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedDocumentType,
                hint: const Text('Sélectionner un document'),
                decoration: _inputDecoration(theme, isDark),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: theme.colorScheme.primary,
                ),
                items: _documentTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un type' : null,
              ),

              const SizedBox(height: 24),
              Text(
                'Veuillez remplir le formulaire ci-dessous pour effectuer une demande de document administratif.',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.text,
                enabled: false,
                decoration: _inputDecoration(theme, isDark).copyWith(
                  prefixIcon: Icon(
                    Icons.explicit,
                    color: theme.iconTheme.color?.withValues(alpha: 0.5),
                  ),
                  label: Text(
                    "Champs du formulaire dynamique selon le document choisi",
                    style: TextStyle(letterSpacing: 1.2),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSectionTitle('Nombre d\'exemplaires', theme),
              const SizedBox(height: 12),
              SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _copiesController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(theme, isDark).copyWith(
                    prefixIcon: Icon(
                      Icons.file_copy_outlined,
                      color: theme.iconTheme.color?.withValues(alpha: 0.5),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        int.tryParse(value) == null ||
                        int.parse(value) < 1) {
                      return 'Entrez un nombre valide';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Soumettre la demande',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: theme.textTheme.titleMedium?.color,
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? theme.cardTheme.color : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? AppColors.darkBorder
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}
