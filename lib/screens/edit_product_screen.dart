import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode =
      FocusNode(); // creating a FocusNode object to implement change in focus
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController =
      TextEditingController(); // to access the value of text form field before the form is submitted
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductProvider>(context).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              (!_imageUrlController.text.endsWith('.jpg') ||
                  !_imageUrlController.text.endsWith('.jpeg')))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      //TODO: add try catch for error handling
      await Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      
    } else {
      try{
        await Provider.of<ProductProvider>(context, listen: false)
          .addProduct(_editedProduct);
      }catch(error){
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Unable to upload object to server'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      // finally{
      //    setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context)
      //       .pop(); // page won't pop unless we return future from product_provider
      // }
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();

    // Navigator.of(context).pop();
    // print(_editedProduct.title);
    // print(_editedProduct.description);
    // print(_editedProduct.id);
    // print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: TextFormField(
                            initialValue: _initValues['title'],
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(
                                  _priceFocusNode); // to shift focus from this input filed to _priceFocusNode
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: value,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Title is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: TextFormField(
                            initialValue: _initValues['price'],
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(
                                  _descriptionFocusNode); // to shift focus from this input filed to _priceFocusNode
                            },
                            focusNode:
                                _priceFocusNode, // setting the focus node so that we can change focus here
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: double.parse(value),
                                description: _editedProduct.description,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a price';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than 0';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: TextFormField(
                            initialValue: _initValues['description'],
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            ),
                            keyboardType: TextInputType.multiline,
                            focusNode:
                                _descriptionFocusNode, // setting the focus node so that we can change focus here
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: value,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Description is required';
                              }
                              if (value.length < 10) {
                                return 'Please describe some more';
                              }
                              return null;
                            },
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                              ),
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                        _imageUrlController.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(
                              child: TextFormField(
                                // initialValue: _initValues['imageUrl'], // controller should be set to initial value
                                decoration:
                                    InputDecoration(labelText: 'Image URL'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    imageUrl: value,
                                    id: _editedProduct.id,
                                    isFavourite: _editedProduct.isFavourite,
                                  );
                                },
                                // validator: (value){
                                //   if (value.isEmpty) {
                                //     return 'Please enter an image URL';
                                //   }
                                //   if (!value.startsWith('http') && !value.startsWith('https')) {
                                //     return 'Please enter a valid image URL';
                                //   }
                                //   if (!value.endsWith('.png') && (!value.endsWith('.jpg') || !value.endsWith('.jpeg'))) {
                                //     return 'The entered URL dosen\'t yield and image';
                                //   }
                                //   return null;
                                // },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
