import 'package:flutter/material.dart';

class GroupDetailsScreen extends StatelessWidget {
  final List groupMembersNameList;
  const GroupDetailsScreen({Key? key, required this.groupMembersNameList}) : super(key: key);

  void submit(_formKey) {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Group detail screen')),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(label: Text('Group name')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '* required';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => submit(_formKey),
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
