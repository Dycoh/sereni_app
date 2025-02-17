// presentation/blocs/journal/journal_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/journal_repository.dart';

// Events
abstract class JournalEvent {}
class LoadJournals extends JournalEvent {}
class AddJournal extends JournalEvent {
  final Map<String, dynamic> journal;
  AddJournal(this.journal);
}

// States
abstract class JournalState {}
class JournalInitial extends JournalState {}
class JournalLoading extends JournalState {}
class JournalsLoaded extends JournalState {
  final List<Map<String, dynamic>> journals;
  JournalsLoaded(this.journals);
}
class JournalError extends JournalState {
  final String message;
  JournalError(this.message);
}

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  final JournalRepository journalRepository;

  JournalBloc({required this.journalRepository}) : super(JournalInitial()) {
    on<LoadJournals>(_onLoadJournals);
    on<AddJournal>(_onAddJournal);
  }

  Future<void> _onLoadJournals(LoadJournals event, Emitter<JournalState> emit) async {
    // Implementation
  }

  Future<void> _onAddJournal(AddJournal event, Emitter<JournalState> emit) async {
    // Implementation
  }
}