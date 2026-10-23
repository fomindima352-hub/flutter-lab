import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Модель данных для карточки
class TransactionCard {
  final String title;
  final String subtitle;
  final String amount;
  final String imageUrl;
  final Color tagColor;

  TransactionCard({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.imageUrl,
    required this.tagColor,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Cards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Фомин Дмитрий ПиБД-33'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Список данных
  final List<TransactionCard> cards = [
    TransactionCard(
      title: 'Продукты',
      subtitle: 'Пятёрочка',
      amount: '- 2 450.50 ₽',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
      tagColor: Colors.green,
    ),
    TransactionCard(
      title: 'Транспорт',
      subtitle: 'Проездной на месяц',
      amount: '- 1 500.00 ₽',
      imageUrl: 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=400',
      tagColor: Colors.blue,
    ),
    TransactionCard(
      title: 'Развлечения',
      subtitle: 'Кино с друзьями',
      amount: '- 800.00 ₽',
      imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=400',
      tagColor: Colors.orange,
    ),
    TransactionCard(
      title: 'Здоровье',
      subtitle: 'Аптека',
      amount: '- 560.00 ₽',
      imageUrl: 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400',
      tagColor: Colors.red,
    ),
    TransactionCard(
      title: 'Зарплата',
      subtitle: 'За сентябрь',
      amount: '+ 80 000.00 ₽',
      imageUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=400',
      tagColor: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final item = cards[index];
          return _buildCard(item);
        },
      ),
    );
  }

  Widget _buildCard(TransactionCard item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Картинка
          Image.network(
            item.imageUrl,
            height: 160,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 160,
                color: Colors.grey.shade200,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, size: 48),
              );
            },
          ),
          // Текстовый блок
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.tagColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.amount,
                        style: TextStyle(
                          color: item.tagColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}