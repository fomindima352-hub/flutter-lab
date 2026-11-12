# Flutter Lab

**Студент:** Фомин Дмитрий  
**Группа:** ПиБД-33

## Лабораторная 1 — Flutter + Android
- Установлен Flutter SDK 3.47.4 и Android Studio
- Создан Flutter-проект (Android)
- Приложение запущено на эмуляторе Android (Medium Phone API 37.2)
- В AppBar выведены ФИО и группа

## Лабораторная 2 — Dart
Файл: `dart_lab/finance.dart` — консольное приложение учёта финансов.

Использованы:
- Классы с полями и методами (`Transaction`, `Wallet`)
- Enums (`TransactionType`, `Category`)
- Loops
- Generics (`filter<T>`)
- Анонимные функции
- Future (`syncFromServer`)
- Extension (`TransactionStats on List<Transaction>`)

Запуск:
## Лабораторная 3 — Список карточек
Файл: `lib/main.dart`.

- Список из 5 карточек транзакций (`ListView.builder`)
- На каждой карточке: картинка (`Image.network`), название, подзаголовок и сумма
- Модель данных: `TransactionCard`
- Данные — финансовые операции: продукты, транспорт, развлечения, здоровье, зарплата
## Лабораторная 5 — Клиент-серверное взаимодействие
- Используется бэкенд Spring Boot (порт 3001) из лабораторных по «Интернет-программированию»
- Архитектура: DTO (`ProjectDto`), интерфейс репозитория (`IProjectRepository`), реализация (`ProjectRepository`)
- Реализована авторизация по JWT (получение токена через `/api/auth/login`)
- Поиск проектов по категории (`/api/project/filter/by-category?category=...`)

## Лабораторная 6 — BLoC и UI
- Логика отделена от UI с использованием `flutter_bloc`
- События: `SearchProjects`, `LoadAllProjects`, `RefreshProjects`
- Состояния: `ProjectInitial`, `ProjectLoading`, `ProjectLoaded`, `ProjectError`
- Реализован **Debounce** (500 мс) на поле поиска
- Реализовано **обновление страницы** (Pull-to-Refresh через `RefreshIndicator`)
