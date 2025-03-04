import 'package:flutter/material.dart';
import 'package:ostadassignment/myColors.dart';

import '../data/repositories/repositories.dart';
import '../theme/buttonTheme.dart';
import 'Service.dart';

class Moveablefab extends StatefulWidget {
  const Moveablefab({super.key});

  @override
  State<Moveablefab> createState() => _MoveablefabState();
}

class _MoveablefabState extends State<Moveablefab> {
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
                //TextField(controller: totalPriceController, decoration: InputDecoration(hintText: 'Total Price'),),
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

  double x = 375; // Initial X position
  double y = 812; // Initial Y position (adjust based on screen size)
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Draggable(
        feedback: FloatingActionButton(
          onPressed: () {
            alertDialogue();
          },
          child: Icon(Icons.add, size: 40, color: Colors.white),
          backgroundColor: MyColors.blue_grey,
          shape: CircleBorder(),
        ),
        childWhenDragging: Container(), // Hide FAB while dragging
        onDragEnd: (details) {
          setState(() {
            x = details.offset.dx;
            y = details.offset.dy;
          });
        },
        child: FloatingActionButton(
          onPressed: () {
            alertDialogue();
          },
          child: Icon(Icons.add, size: 40, color: Colors.white),
          backgroundColor: MyColors.blue_grey,
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
