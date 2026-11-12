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
sealed class MarkdownBlockParentNode<T extends MarkdownNode> extends MarkdownBlockNode {
  MarkdownBlockParentNode(
    Iterable<T> children,
  ) : children = List.unmodifiable(children);

  final List<T> children;

  @override
  List<Object?> get props => [children];
}

@immutable
sealed class MarkdownInlineNode extends MarkdownNode {
  const MarkdownInlineNode();
}

@immutable
sealed class MarkdownInlineParentNode<T extends MarkdownNode> extends MarkdownInlineNode {
  MarkdownInlineParentNode(
    Iterable<T> children,
  ) : children = List.unmodifiable(children);

  final List<T> children;

  @override
  List<Object?> get props => [children];
}
