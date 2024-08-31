import 'package:chat1/core/api/apis.dart';
import 'package:chat1/core/colors.dart';
import 'package:flutter/material.dart';


class ProfileEditPage extends StatefulWidget {
  final String title;
  final String value;
  final String? userid;
  //!!! تعديل ال يوزر عملتها عشان اعدل كل اليوزر

  const ProfileEditPage({
    super.key,
    required this.title,
    required this.value,
    this.userid,
  });

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(

        backgroundColor: MyColors.backgroundColor,
        
        title: Text('Edit ${widget.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _value,
                decoration: InputDecoration(
                  labelText: widget.title,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ${widget.title.toLowerCase()}';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _value = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    //widget.onSaved(_value);
                    await APIs.updateUserInfo(
                       widget.userid ?? APIs.me.id,
                        widget.title == "Name" ? _value : null,
                        widget.title == "About" ? _value : null);
               

                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
