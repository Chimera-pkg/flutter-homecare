part of 'feedback_cubit.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {
  final FeedbackEntity feedback;

  const FeedbackSuccess(this.feedback);

  @override
  List<Object> get props => [feedback];
}

class FeedbackFailure extends FeedbackState {
  final String message;

  const FeedbackFailure(this.message);

  @override
  List<Object> get props => [message];
}