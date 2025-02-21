//
//  Generated code. Do not modify.
//  source: lib/tasklist.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use taskItemDescriptor instead')
const TaskItem$json = {
  '1': 'TaskItem',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'completed_subtasks', '3': 3, '4': 3, '5': 9, '10': 'completedSubtasks'},
    {'1': 'subtasks', '3': 4, '4': 3, '5': 9, '10': 'subtasks'},
  ],
};

/// Descriptor for `TaskItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskItemDescriptor = $convert.base64Decode(
    'CghUYXNrSXRlbRISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZX'
    'NjcmlwdGlvbhItChJjb21wbGV0ZWRfc3VidGFza3MYAyADKAlSEWNvbXBsZXRlZFN1YnRhc2tz'
    'EhoKCHN1YnRhc2tzGAQgAygJUghzdWJ0YXNrcw==');

@$core.Deprecated('Use taskListDescriptor instead')
const TaskList$json = {
  '1': 'TaskList',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 11, '6': '.TaskItem', '10': 'tasks'},
  ],
};

/// Descriptor for `TaskList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskListDescriptor = $convert.base64Decode(
    'CghUYXNrTGlzdBIfCgV0YXNrcxgBIAMoCzIJLlRhc2tJdGVtUgV0YXNrcw==');

