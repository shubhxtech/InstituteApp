part of 'job_bloc.dart';

abstract class JobPortalEvent extends Equatable {
  const JobPortalEvent();

  @override
  List<Object> get props => [];
}

class GetJobsEvent extends JobPortalEvent {
  const GetJobsEvent();
}
