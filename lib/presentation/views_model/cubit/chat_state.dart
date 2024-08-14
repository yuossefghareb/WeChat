part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class AllMessagesSuccess extends ChatState {
  final List data;
  AllMessagesSuccess(this.data);
}

final class AllMessagesError extends ChatState {
  final String error;
  AllMessagesError(this.error);
}

final class AllMessagesLoading extends ChatState {}