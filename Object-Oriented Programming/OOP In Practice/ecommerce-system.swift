/*
 =========================================
 Challenge: E-Commerce System
 =========================================

 We need a simple e-commerce system where customers
 can browse products, add them to a cart, and place orders.

 There are two types of products: physical and digital.
 Both have a name and a price, but they behave differently.

 A physical product has a stock count. when a customer
 adds it to their cart, the stock decreases. if the
 stock is zero, the product should be unavailable and
 the purchase should be rejected.

 A digital product has no stock limit, it can be
 purchased unlimited times. but it has a license key
 that gets assigned to the customer on purchase.

 Both product types have an abstract method purchase()
 that returns a String describing what happened.
 the base class should enforce this using fatalError().

 A cart belongs to a customer and holds a list of products.
 the customer can add products, remove them, and place
 an order. placing an order should call purchase() on
 each product and print a summary.

 The price of a product must be protected. nobody should
 be able to set it directly from outside. a product
 cannot be created with a negative price, use a failable
 initializer to handle this.

 The store keeps a list of all products and all customers.
 it can list all available products and their details.

 =========================================
 */
