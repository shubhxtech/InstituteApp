part of 'job_bloc.dart';

abstract class JobPortalState extends Equatable {
  const JobPortalState();

  @override
  List<Object> get props => [];
}

class JobPortalInitial extends JobPortalState {}

class JobsLoading extends JobPortalState {}

class JobsLoaded extends JobPortalState {
  final List<JobEntity> jobs;

  const JobsLoaded({required this.jobs});
}

class JobsLoadingError extends JobPortalState {
  final String message;

  const JobsLoadingError({required this.message});
}
