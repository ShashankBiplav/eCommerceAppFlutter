import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/navigation_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer:NavigationDrawer() ,
      body: ListView.builder(
        itemCount: orders.items.length,
        itemBuilder: (ctx, i) => OrderItem(
          orders.items[i],
        ),
      ),
    );
  }
}
