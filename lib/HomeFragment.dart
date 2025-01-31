import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'myColors.dart';

class Homefragment extends StatefulWidget {
  const Homefragment({super.key});

  @override
  State<Homefragment> createState() => _HomefragmentState();
}

class _HomefragmentState extends State<Homefragment> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  void loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedContacts = prefs.getString('contacts');
    if (storedContacts != null) {
      setState(() {
        contacts = List<Map<String, dynamic>>.from(json.decode(storedContacts));
      });
    }
  }

  void saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('contacts', json.encode(contacts));
  }

  void addContact() {
    String name = nameController.text.trim();
    String number = numberController.text.trim();

    RegExp phoneRegex = RegExp(r'^01[3-9][0-9]{8}$');

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Enter Your Name')),
      );
      return;
    }
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Enter Your Number')),
      );
      return;
    }

    if (!phoneRegex.hasMatch(number)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid phone number! Must be 11 digits and start with 01[3-9]')),
      );
      return;
    }

    setState(() {
      contacts.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'number': number,
        'time': DateTime.now().toString(),
      });
      nameController.clear();
      numberController.clear();
    });
    saveContacts();
  }


  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Are you sure for Delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.content_paste_off,color: MyColors.blue,),
          ),
          TextButton(
            onPressed: () {
              deleteContact(id);
              Navigator.pop(context);
            },
            child: Icon(Icons.delete,color: MyColors.blue,),
          ),
        ],
      ),
    );
  }

  void deleteContact(String id) {
    setState(() {
      contacts.removeWhere((contact) => contact['id'] == id);
    });
    saveContacts();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.blue_grey,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MyColors.blue_grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.blue_grey,
            title: Center
              (child: Text('Contact List',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: MyColors.white
            ),))),
        body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height:  20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                            color: MyColors.blue_grey,

                          ),
                          hintText: 'Enter Your Name',
                          hintStyle: TextStyle(color: MyColors.off_white),
                          prefixIcon: Icon(Icons.person, color: MyColors.blue_grey),
                          // Icon color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.blue_grey,
                              width: 2.0.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.blue_grey,

                              width: 2.0.w,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.red,
                              width: 2.0.w,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.red,
                              width: 2.0.w,
                            ),
                          ),
                          fillColor: MyColors.white,
                          filled: true,
                          errorStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                            height: 0.5.h,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: MyColors.deep_blue,
                        ),
                        keyboardType: TextInputType.text,

                        cursorColor: MyColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: numberController,
                        decoration: InputDecoration(
                          labelText: 'Number',
                          labelStyle: TextStyle(
                            color: MyColors.blue_grey,

                          ),

                          hintText: 'Enter Your Number',
                          hintStyle: TextStyle(color: MyColors.off_white),
                          prefixIcon: Icon(Icons.phone, color: MyColors.blue_grey),
                          // Icon color
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.blue_grey,
                              width: 2.0.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.blue_grey,

                              width: 2.0.w,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.red,
                              width: 2.0.w,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: MyColors.red,
                              width: 2.0.w,
                            ),
                          ),
                          fillColor: MyColors.white,
                          filled: true,
                          errorStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                            height: 0.5.h,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: MyColors.deep_blue,
                        ),
                        keyboardType: TextInputType.phone,
                        maxLength: 11,

                        cursorColor: MyColors.green,
                        validator: (value) {
                          if (value == null || !RegExp(r'^01[3-9][0-9]{8}$').hasMatch(value)) {
                            return 'Enter a valid 11-digit number starting with 01[3-9]';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 10),

              Padding(
                padding:  EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: addContact,
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: MyColors.blue_grey,
                      borderRadius: BorderRadius.circular(5.r)

                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Text('Add Contact',
                              style: TextStyle(fontSize: 20.sp,
                              color: MyColors.white
                              ),)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(

                child: Padding(
                  padding: EdgeInsets.only(left: 10.w,right: 10.w),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return Column(
                        children: [
                          Container(

                            decoration: BoxDecoration(
                              color: MyColors.off_grey_white,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(contact['name'],style: TextStyle(
                                  color: MyColors.red,
                                  fontSize: 18.sp
                              ),),
                              subtitle: Text(contact['number'],style: TextStyle(
                                  color: MyColors.deep_blue,
                                  fontSize: 15.sp
                              ),),
                              trailing: Icon(Icons.phone,color: MyColors.blue,),
                              onLongPress: () => confirmDelete(contact['id'],),


                            ),
                          ),
                          SizedBox(height: 10.h,)
                        ],
                      );
                    },
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
