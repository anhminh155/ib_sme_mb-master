// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => IssueModel(
      answer: json['answer'] as String?,
      id: json['id'] as int?,
      question: json['question'] as String?,
      status: json['status'] as int?,
    );

Map<String, dynamic> _$IssueModelToJson(IssueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answer': instance.answer,
      'question': instance.question,
      'status': instance.status,
    };
