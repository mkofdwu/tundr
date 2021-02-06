class Account {
  final String username;
  final String password;
  bool exists; // if its persisted in the database before testing

  Account(this.username, this.password, {this.exists});
}

class Accounts {
  // john will be created and then deleted after test is completed
  static final john = Account('john', 'password2', exists: false);
  static final mary = Account('mary', 'testee', exists: false);
  static final test = Account('test', '123456', exists: true);

  static Account current;
}
