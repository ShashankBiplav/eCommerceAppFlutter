import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/product_provider.dart';
import './providers/cart_provider.dart';
import './providers/order_provider.dart';
import './providers/auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          // create: (ctx)=>ProductProvider(authToken, _items),
          update: (ctx, auth, previousProducts) => ProductProvider( auth.token,auth.userId ,previousProducts == null ? []: previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          update: (ctx,auth, previousOrders) => OrderProvider(auth.token,previousOrders == null ? [] : previousOrders.items),
        ),
      ], // provider version >3 using create: instead of builder:
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'eCommerce',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              // errorColor: Colors.red,
              fontFamily: 'Lato'),
          home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            // AuthScreen.routeName :(ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
