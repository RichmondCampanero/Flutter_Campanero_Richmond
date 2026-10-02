import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: StudentForm()));

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  String? gender;      // state: selected gender
  String result = '';  // state: text shown after submitting
  int resetCount = 0;  // used to clear the dropdown

  // Validator for fields that only need to be filled in
  String? checkRequired(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        result = 'Full Name: ${nameController.text}\n'
            'Age: ${ageController.text}\n'
            'Gender: $gender\n'
            'Address: ${addressController.text}\n'
            'Contact Number: ${contactController.text}\n'
            'Email: ${emailController.text}';
      });
    }
  }

  void clear() {
    _formKey.currentState!.reset(); // clears all text fields and error messages
    setState(() {
      gender = null;
      result = '';
      resetCount++;
    });
  }

  // Builds one text field so we don't repeat the same code six times
  Widget buildField(String label, TextEditingController controller,
      {String? Function(String?)? validator, TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator ?? checkRequired,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField('Full Name', nameController),

              buildField('Age', ageController, type: TextInputType.number,
                  validator: (value) {
                if (value == null || value.isEmpty) return 'Age is required';
                if (int.tryParse(value) == null) return 'Age must be a number';
                return null;
              }),

              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButtonFormField<String>(
                  key: ValueKey(resetCount),
                  value: gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Male', 'Female']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => gender = value),
                  validator: (value) =>
                      value == null ? 'Please select a gender' : null,
                ),
              ),

              buildField('Address', addressController),

              buildField('Contact Number', contactController,
                  type: TextInputType.phone, validator: (value) {
                if (value == null || value.isEmpty) return 'Contact number is required';
                if (value.length < 10 || int.tryParse(value) == null) {
                  return 'Enter a valid contact number';
                }
                return null;
              }),

              buildField('Email', emailController,
                  type: TextInputType.emailAddress, validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!value.contains('@')) return 'Enter a valid email';
                return null;
              }),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: submit, child: const Text('Submit')),
                  const SizedBox(width: 16),
                  OutlinedButton(onPressed: clear, child: const Text('Clear')),
                ],
              ),

              // Only shown after a successful submit
              if (result.isNotEmpty)
                Card(
                  margin: const EdgeInsets.only(top: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(width: double.infinity, child: Text(result)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
