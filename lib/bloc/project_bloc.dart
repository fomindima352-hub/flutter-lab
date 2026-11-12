import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/dto/project_dto.dart';
import '../data/repositories/project_repository.dart';

// --- События ---
abstract class ProjectEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchProjects extends ProjectEvent {
  final String query;
  SearchProjects(this.query);
  @override
  List<Object> get props => [query];
}

class LoadAllProjects extends ProjectEvent {}

class RefreshProjects extends ProjectEvent {
  final String currentQuery;
  RefreshProjects(this.currentQuery);
  @override
  List<Object> get props => [currentQuery];
}

// --- Состояния ---
abstract class ProjectState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}
class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectDto> projects;
  ProjectLoaded(this.projects);
  @override
  List<Object> get props => [projects];
}

class ProjectError extends ProjectState {
  final String message;
  ProjectError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final IProjectRepository repository;
  String _currentSearch = '';

  ProjectBloc(this.repository) : super(ProjectInitial()) {
    // Поиск
    on<SearchProjects>((event, emit) async {
      _currentSearch = event.query;
      emit(ProjectLoading());
      try {
        final projects = await repository.searchProjects(event.query);
        emit(ProjectLoaded(projects));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    // Загрузка всех при старте
    on<LoadAllProjects>((event, emit) async {
      _currentSearch = '';
      emit(ProjectLoading());
      try {
        final projects = await repository.getAllProjects();
        emit(ProjectLoaded(projects));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });

    // Обновление (Pull to Refresh)
    on<RefreshProjects>((event, emit) async {
      try {
        final projects = await repository.searchProjects(event.currentQuery);
        emit(ProjectLoaded(projects));
      } catch (e) {
        emit(ProjectError(e.toString()));
      }
    });
  }
}