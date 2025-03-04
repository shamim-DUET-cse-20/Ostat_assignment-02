import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ostadassignment/Service/Service.dart';
import 'package:ostadassignment/theme/buttonTheme.dart';
import 'package:ostadassignment/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/repositories.dart';
import 'myColors.dart';

class Homefragment extends StatefulWidget {
  const Homefragment({super.key});

  @override
  State<Homefragment> createState() => _HomefragmentState();
}

class _HomefragmentState extends State<Homefragment> {
  final repositories productController = repositories();

  Future<void> fetchData() async {
    await productController.fetchProduct();
    print(productController.product.length);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  alertDialogue({String? id,String? productName, String? img, int? qty, int? unitPrice, int? totalPrice,
  })
  {
    TextEditingController productNameController = TextEditingController();
    TextEditingController imgController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    TextEditingController unitPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();

    if (id != null) {
      productNameController.text = productName.toString();
      imgController.text = img.toString();
      qtyController.text = qty.toString();
      unitPriceController.text = unitPrice.toString();
      totalPriceController.text = totalPrice.toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              id == null ? Text('Add Product') : Text('Update Product'),
            ],
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: productNameController, decoration: InputDecoration(hintText: 'Product Name'),),
                TextField(controller: imgController, decoration: InputDecoration(hintText: 'Image URL'),),
                TextField(controller: qtyController, decoration: InputDecoration(hintText: 'Quantity'),),
                TextField(controller: unitPriceController, decoration: InputDecoration(hintText: 'Unit Price'),),
                TextField(controller: totalPriceController, decoration: InputDecoration(hintText: 'Total Price'),),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel',style: TextStyle(color: MyColors.white),),
                      style: buttonStyle(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await productController.createProduct(
                            productName: productNameController.text,
                            imageUrl: imgController.text,
                            qty: int.parse(qtyController.text.toString()),
                            unitPrice: int.parse(unitPriceController.text),

                          );
                          CustomDesign.snackbar( 'Product add successfully');
                        } else {
                          await productController.updateProduct(
                            id: id,
                            productName: productNameController.text,
                            img: imgController.text,
                            qty: int.parse(qtyController.text),
                            unitPrice: int.parse(unitPriceController.text),
                          );
                          CustomDesign.snackbar( 'Product Update Successfully');
                        }
                        setState(() {});
                        Navigator.pop(context);
                        fetchData();
                      },
                      child: id == null ? Text('Add ') : Text('Update'),
                      style: buttonStyle(), //use from button theme
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
        backgroundColor: MyColors.grey_white,
        appBar: AppBar(
          backgroundColor: MyColors.grey_white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Height of the divider
            child: Container(
              color: MyColors.off_grey_white, // Divider color
              height: 1.0, // Thickness of the divider
            ),
          ),
          title: Center(
            child: Text(
              'CRUD API',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyColors.deep_blue,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [

                SizedBox(height: 20.h,),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h), // Ensure FAB is visible
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 245,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: productController.product.length,
                    itemBuilder: (BuildContext context, int index) {
                      var product = productController.product[index];
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: MyColors.off_grey_white,
                            border: Border.all(width: 1.w,color: MyColors.deep_blue),
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.deep_blue.withOpacity(0.5),
                                blurRadius: 3,
                                offset: Offset(0, 0),
                                spreadRadius: 1,
                              )
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Product Image
                            Padding(
                              padding:  EdgeInsets.all(4.0),
                              child: Container(
                                height: 130,
                                width: 155,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.img.toString().trim(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image),
                                          Text('Image Not Found'),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Product Details
                            Container(
                              padding: EdgeInsets.all(5),
                              //height: 40,
                              width: 155,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 110,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name: ${product.productName}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Price: ${product.unitPrice} | Quantity: ${product.qty}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Total Price: ${product.totalPrice} ',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    left: 115,
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: MyColors.blue_grey,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Icon(
                                        Icons.add_shopping_cart_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Edit and Delete Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    alertDialogue(
                                      productName: product.productName,
                                      id: product.sId,
                                      img: product.img,
                                      qty: product.qty,
                                      unitPrice: product.unitPrice,
                                      totalPrice: product.totalPrice,
                                    );
                                    fetchData();
                                    setState(() {});
                                  },
                                  child: Icon(Icons.edit, color: Colors.white),
                                  style: buttonStyle(),
                                ),
                                OutlinedButton(
                                  onPressed: () async {
                                    await productController.deleteProduct(id: product.sId ?? '');
                                    await fetchData();
                                    setState(() {});
                                    CustomDesign.snackbar('Product Deleted Successfully');
                                  },
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                  style: buttonStyle(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),

            // Floating Action Button Positioned at Bottom
            Positioned(
              bottom: 50, // Adjust the distance from the bottom
              right: 40, // Adjust the distance from the right
              child: FloatingActionButton(
                onPressed: () {
                  alertDialogue();
                },
                child: Icon(Icons.add, size: 40, color: Colors.white),
                backgroundColor: MyColors.blue_grey,
                shape: CircleBorder(),
              ),
            ),


          ],
        ),
      ),
    );

  }
}
