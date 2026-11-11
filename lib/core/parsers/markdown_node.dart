import 'package:flutter/foundation.dart';

@immutable
sealed class MarkdownNode {
  const MarkdownNode();
}

final class MarkdownDocumentNode extends MarkdownNode {
  MarkdownDocumentNode(
    Iterable<MarkdownBlockNode> children,
  ) : children = List.unmodifiable(children);

  final List<MarkdownBlockNode> children;
}

@immutable
sealed class MarkdownBlockNode extends MarkdownNode {
  const MarkdownBlockNode();
}
