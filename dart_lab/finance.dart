// ============ ENUMS ============
enum TransactionType {
  income,
  expense,
}

enum Category {
  food,
  transport,
  entertainment,
  utilities,
  health,
  salary,
  other,
}

// ============ КЛАССЫ С ПОЛЯМИ И МЕТОДАМИ ============
class Transaction {
  final String description;
  final double amount; // всегда положительное
  final TransactionType type;
  final Category category;
  final DateTime date;

  Transaction({
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  /// Со знаком: доход +, расход -
  double get signedAmount =>
      type == TransactionType.income ? amount : -amount;

  @override
  String toString() {
    final sign = type == TransactionType.income ? '+' : '-';
    final d = '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
    return '$d  $sign${amount.toStringAsFixed(2)}  '
        '[${category.name}]  $description';
  }
}

class Wallet {
  final String owner;
  final List<Transaction> _transactions = [];

  Wallet(this.owner);

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  /// Баланс — LOOP + ANONYMOUS FUNCTION через fold
  double get balance => _transactions.fold(
    0.0,
        (sum, t) => sum + t.signedAmount,
  );

  void add(Transaction t) => _transactions.add(t);

  void addAll(Iterable<Transaction> ts) => _transactions.addAll(ts);

  /// GENERICS: обобщённая фильтрация
  List<T> filter<T>(bool Function(T) predicate) {
    final result = <T>[];
    for (final item in _transactions.whereType<T>()) {
      if (predicate(item)) result.add(item);
    }
    return result;
  }

  /// LOOP + ANONYMOUS FUNCTION
  void printAll() {
    print('Кошелёк: $owner  (${_transactions.length} операций)');
    _transactions.forEach((t) => print('  $t'));
    print('  Баланс: ${balance.toStringAsFixed(2)} руб.');
  }

  /// FUTURE: асинхронная «синхронизация с сервером»
  Future<List<Transaction>> syncFromServer() async {
    print('Синхронизация с сервером...');
    await Future.delayed(const Duration(seconds: 1));
    final remote = <Transaction>[
      Transaction(
        description: 'Зарплата за сентябрь',
        amount: 80000,
        type: TransactionType.income,
        category: Category.salary,
        date: DateTime(2026, 9, 30),
      ),
      Transaction(
        description: 'Продукты в Пятёрочке',
        amount: 2450.50,
        type: TransactionType.expense,
        category: Category.food,
        date: DateTime(2026, 10, 1),
      ),
      Transaction(
        description: 'Проездной на месяц',
        amount: 1500,
        type: TransactionType.expense,
        category: Category.transport,
        date: DateTime(2026, 10, 1),
      ),
    ];
    _transactions.addAll(remote);
    print('Синхронизировано ${remote.length} операций.');
    return remote;
  }
}

// ============ EXTENSION ============
extension TransactionStats on List<Transaction> {
  /// Сумма по категории
  double totalByCategory(Category category) => where(
        (t) =>
    t.category == category &&
        t.type == TransactionType.expense,
  ).fold(0.0, (s, t) => s + t.amount);

  /// Топ-N крупнейших расходов
  List<Transaction> topExpenses(int n) {
    final expenses = where((t) => t.type == TransactionType.expense).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return expenses.take(n).toList();
  }

  /// Средний расход
  double averageExpense() {
    final expenses =
    where((t) => t.type == TransactionType.expense).toList();
    if (expenses.isEmpty) return 0;
    return expenses.fold(0.0, (s, t) => s + t.amount) / expenses.length;
  }
}

// ============ MAIN ============
Future<void> main() async {
  final wallet = Wallet('Дмитрий');

  // Ручные операции
  wallet.add(Transaction(
    description: 'Кофе в универе',
    amount: 250,
    type: TransactionType.expense,
    category: Category.food,
    date: DateTime(2026, 10, 1),
  ));
  wallet.add(Transaction(
    description: 'Подработка',
    amount: 15000,
    type: TransactionType.income,
    category: Category.other,
    date: DateTime(2026, 10, 1),
  ));

  print('--- До синхронизации ---');
  wallet.printAll();

  // FUTURE: подгружаем с сервера
  await wallet.syncFromServer();

  print('\n--- После синхронизации ---');
  wallet.printAll();

  // GENERICS: filter<Transaction> с анонимной функцией
  final largeExpenses =
  wallet.filter<Transaction>((t) => t.amount > 1000);
  print('\nОперации крупнее 1000 руб:');
  largeExpenses.forEach((t) => print('  → $t'));

  // EXTENSION: статистика
  final all = wallet.transactions;
  print('\nСтатистика:');
  print('  Всего операций: ${all.length}');
  print('  Продукты: ${all.totalByCategory(Category.food).toStringAsFixed(2)} руб.');
  print('  Транспорт: ${all.totalByCategory(Category.transport).toStringAsFixed(2)} руб.');
  print('  Средний расход: ${all.averageExpense().toStringAsFixed(2)} руб.');

  print('\nТоп-3 расходов:');
  all.topExpenses(3).forEach((t) => print('  * $t'));
}