import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:peatdashboard/models/feeder.dart';
import 'package:peatdashboard/services/peat_data_service.dart';
import 'package:peatdashboard/utils/app_colors.dart';
import 'package:peatdashboard/utils/phone_input_formatter.dart';

class NotificationFormScreen extends StatefulWidget {
  const NotificationFormScreen({super.key});

  @override
  _NotificationFormScreenState createState() => _NotificationFormScreenState();
}

class _NotificationFormScreenState extends State<NotificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  Feeder? _selectedFeeder;
  final List<Feeder> _feeders = [
    Feeder(
      id: "1",
      name: 'Comedouro IFCE',
      location: const LatLng(-3.744340487400293, -38.53604795635519),
    ),
    Feeder(
      id: "2",
      name: 'Comedouro UECE',
      location: const LatLng(-3.788079524593659, -38.553419371763795),
    ),
    Feeder(
      id: "3",
      name: 'Comedouro UNIFOR',
      location: const LatLng(-3.768765932570104, -38.47806435259981),
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (_feeders.isNotEmpty) {
      _selectedFeeder = _feeders.first;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_emailController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Preencha o email ou o telefone para cadastrar.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final contactName = _nameController.text.trim();
    final feederName = _selectedFeeder!.name;
    final combinedName = "$contactName ($feederName)";

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    String? errorMessage;

    try {
      List<Future> apiCalls = [];

      if (email.isNotEmpty) {
        apiCalls.add(PeatDataService.addEmail(combinedName, email));
      }
      if (phone.isNotEmpty) {
        apiCalls.add(PeatDataService.addPhone(combinedName, phone));
      }

      final results = await Future.wait(apiCalls);

      for (var response in results) {
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw Exception('Falha ao cadastrar: ${response.body}');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados cadastrados com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      setState(() => _isLoading = false);
      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage!)),
        );
      }
    }
  }

  Widget _buildFeederSelector() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final dropdownColor =
        isDarkMode ? AppColors.darkCardColor : AppColors.lightBackgroundColor;

    return DropdownButtonFormField<Feeder>(
      value: _selectedFeeder,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Comedouro',
        border: OutlineInputBorder(),
      ),
      dropdownColor: dropdownColor,
      onChanged: (Feeder? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedFeeder = newValue;
          });
        }
      },
      items: _feeders.map<DropdownMenuItem<Feeder>>((Feeder feeder) {
        return DropdownMenuItem<Feeder>(
          value: feeder,
          child: Text(feeder.name),
        );
      }).toList(),
    );
  }

  Widget _buildInfoText(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.pets,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Seja um Anjo da Guarda PEAT!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Ao se cadastrar, você se torna parte essencial do nosso projeto de cuidado com os gatinhos em situação de abandono.\n\nNós te avisaremos por e-mail sempre que a ração do comedouro estiver acabando (abaixo de 20%), para que juntos a gente garanta que eles nunca fiquem sem alimento.',
            style: TextStyle(color: textColor, height: 1.5, fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.darkBackgroundColor : AppColors.lightBackgroundColor;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text('Monitorar Comedouro', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFeederSelector(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Seu Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Seu nome é importante para nós!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Seu Melhor Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      (!value.contains('@') || !value.contains('.'))) {
                    return 'Por favor, insira um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Seu Telefone (Opcional)',
                  hintText: '(XX) X XXXX-XXXX',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  PhoneInputFormatter(),
                ],
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      value.replaceAll(RegExp(r'\D'), '').length != 11) {
                    return 'O telefone deve ter 11 dígitos.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('QUERO AJUDAR!'),
              ),
              _buildInfoText(context),
            ],
          ),
        ),
      ),
    );
  }
}