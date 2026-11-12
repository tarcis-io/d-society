import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class MarkdownNode extends Equatable {
  const MarkdownNode();
}

@immutable
sealed class MarkdownBlockNode extends MarkdownNode {
  const MarkdownBlockNode();
}

@immutable
sealed class MarkdownBlockParentNode extends MarkdownBlockNode {
  MarkdownBlockParentNode(
    Iterable<MarkdownBlockNode> children,
  ) : children = List.unmodifiable(children);

  final List<MarkdownBlockNode> children;

  @override
  List<Object?> get props => [children];
}

@immutable
sealed class MarkdownInlineNode extends MarkdownNode {
  const MarkdownInlineNode();
}

@immutable
sealed class MarkdownInlineParentNode extends MarkdownInlineNode {
  MarkdownInlineParentNode(
    Iterable<MarkdownInlineNode> children,
  ) : children = List.unmodifiable(children);

  final List<MarkdownInlineNode> children;

  @override
  List<Object?> get props => [children];
}
