/*
 =========================================
 Challenge: Banking System
 =========================================

 We need a simple banking system where customers can open
 accounts, deposit money, and withdraw money.

 The bank has two types of accounts: savings and checking.
 Both share common behavior like depositing and withdrawing,
 but each has its own rules.

 A savings account earns interest. the bank can call
 applyInterest() on it at any time to add a percentage
 of the current balance to the account.

 A checking account has an overdraft limit. the customer
 can withdraw more than their balance, but only up to
 that limit. going beyond it should be rejected.

 The balance of any account must be protected. nobody
 should be able to set it directly from outside, only
 through deposit() and withdraw(). both methods should
 validate the amount and reject negative or zero values.

 The bank keeps a list of all accounts and can print
 the details of each one. when listing, it should be
 clear whether each account is a savings or checking account.

 An account cannot be created with a negative balance.
 use a failable initializer to handle this.

 =========================================
 */
