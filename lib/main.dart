import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/project_bloc.dart';
import 'data/dto/project_dto.dart';
import 'data/repositories/project_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Благотворительность',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: RepositoryProvider(
        create: (context) => ProjectRepository(),
        child: BlocProvider(
          create: (context) => ProjectBloc(
            RepositoryProvider.of<ProjectRepository>(context),
          )..add(LoadAllProjects()), // Сразу грузим данные
          child: const ProjectListPage(),
        ),
      ),
    );
  }
}

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // DEBOUNCE НА ПОИСК
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ProjectBloc>().add(SearchProjects(query));
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фомин Дмитрий ПиБД-33'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // ПОЛЕ ПОИСКА
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Поиск по категории (Дети, Животные...)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // СПИСОК
          Expanded(
            child: BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProjectError) {
                  return Center(child: Text('Ошибка: ${state.message}', style: const TextStyle(color: Colors.red)));
                } else if (state is ProjectLoaded) {
                  if (state.projects.isEmpty) {
                    return const Center(child: Text('Ничего не найдено'));
                  }

                  // ОБНОВЛЕНИЕ СТРАНИЦЫ (PULL TO REFRESH)
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProjectBloc>().add(RefreshProjects(_searchController.text));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.projects.length,
                      itemBuilder: (context, index) {
                        return _buildCard(state.projects[index]);
                      },
                    ),
                  );
                }
                return const Center(child: Text('Загрузка...'));
              },
            ),
          ),
        ],
      ),
    );
  }

  // Дизайн карточки проекта
  Widget _buildCard(ProjectDto project) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Иконка-эмодзи
            Text(project.icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            // Текст
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(project.category, style: TextStyle(color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  // Прогресс-бар сбора
                  LinearProgressIndicator(
                    value: project.target > 0 ? project.collected / project.target : 0,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Собрано: ${project.collected} из ${project.target} ₽',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}