class MoreStoryEvent {
  MoreStoryEvent();
}

class MoreMonitoring {
  MoreMonitoring();
}

class MoreCommunityEvent {
  MoreCommunityEvent();
}

class AddCommunityEvent {
  AddCommunityEvent();
}

class EditCommunityEvent {
  EditCommunityEvent();
}

class AddChildrenEvent {
  AddChildrenEvent();
}

class AddAskEvent {
  AddAskEvent();
}

class SelectChildEvent {
  SelectChildEvent();
}

class SelectBodyBrainEvent {
  SelectBodyBrainEvent();
}

class UpdateUserEvent {
  UpdateUserEvent();
}

class UpdateChildEvent {
  UpdateChildEvent();
}

class ReceivePushEvent {
  ReceivePushEvent();
}

class UpdateShippingAddressEvent {
  UpdateShippingAddressEvent();
}

class AddReviewEvent {
  AddReviewEvent();
}

class DeleteReviewEvent {
  DeleteReviewEvent();
}

class EditReviewEvent {
  EditReviewEvent();
}

class PaymentFinish {
  String order_id;

  PaymentFinish({
    required this.order_id,
  });
}

class OrderHistoryEvent {
  OrderHistoryEvent();
}

class UpdateQuizEvent {
  UpdateQuizEvent();
}

class CheckChatQuizEvent {
  String chat_info;

  CheckChatQuizEvent({
    required this.chat_info,
  });
}

class MoreHomeCareEvent {
  int type;

  MoreHomeCareEvent({
    required this.type,
  });
}

class HomeCareTabEvent {
  int type;

  HomeCareTabEvent({
    required this.type,
  });
}

class HomeBrainTabEvent {
  int type;

  HomeBrainTabEvent({
    required this.type,
  });
}

class SubTabEvent {
  int type;

  SubTabEvent({
    required this.type,
  });
}

class InfoTabEvent {
  int type;

  InfoTabEvent({
    required this.type,
  });
}

class MonitoringFinishEvent {
  MonitoringFinishEvent();
}
