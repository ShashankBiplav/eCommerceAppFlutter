import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/navigation_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<OrderProvider>(context, listen: false).fetchAndSetOrders().then((_){
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: NavigationDrawer(),
      body:_isLoading?Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (ctx, i) => OrderItem(
          orders.items[i],
        ),
      ),
    );
  }
}
