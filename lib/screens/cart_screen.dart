import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart' as ci;
import '../providers/order_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => ci.CartItem(
                id: cart.items.values
                    .toList()[i]
                    .id, //used .values.toList() because we get a map from CartProvider
                productId: cart.items.keys.toList()[i],
                title: cart.items.values
                    .toList()[i]
                    .title, //used .values.toList() because we get a map from CartProvider
                quantity: cart.items.values
                    .toList()[i]
                    .quantity, //used .values.toList() because we get a map from CartProvider
                price: cart.items.values
                    .toList()[i]
                    .price, //used .values.toList() because we get a map from CartProvider
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)  // if cart has nothing then disable button
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
             await Provider.of<OrderProvider>(context, listen: false)
                  .addOrder(widget.cart.items.values.toList(),
                      widget.cart.totalAmount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearCart();
            },
      child:_isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
