import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class MarkdownNode extends Equatable {
  const MarkdownNode();

  @override
  List<Object?> get props => [];
}

@immutable
sealed class MarkdownBlockNode extends MarkdownNode {
  const MarkdownBlockNode();
}

final class MarkdownCodeBlockNode extends MarkdownBlockNode {
  const MarkdownCodeBlockNode(this.text, {this.language});

  final String text;
  final String? language;

  @override
  List<Object?> get props => [...super.props, text, language];
}

final class MarkdownThematicBreakNode extends MarkdownBlockNode {
  const MarkdownThematicBreakNode();
}

final class MarkdownHtmlBlockNode extends MarkdownBlockNode {
  const MarkdownHtmlBlockNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MarkdownMathBlockNode extends MarkdownBlockNode {
  const MarkdownMathBlockNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

@immutable
sealed class MarkdownBlockParentNode<T extends MarkdownNode> extends MarkdownBlockNode {
  MarkdownBlockParentNode(Iterable<T> children) : children = List.unmodifiable(children);

  final List<T> children;

  @override
  List<Object?> get props => [...super.props, children];
}

final class MarkdownDocumentNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  MarkdownDocumentNode(super.children);
}

final class MarkdownParagraphNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  MarkdownParagraphNode(super.children);
}

final class MarkdownHeadingNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  MarkdownHeadingNode(super.children, {required this.level});

  final int level;

  @override
  List<Object?> get props => [...super.props, level];
}

final class MarkdownBlockQuoteNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  MarkdownBlockQuoteNode(super.children);
}

final class MarkdownListNode extends MarkdownBlockParentNode<MarkdownListItemNode> {
  MarkdownListNode(super.children, {required this.isOrdered, this.startNumber});

  final bool isOrdered;
  final int? startNumber;

  @override
  List<Object?> get props => [...super.props, isOrdered, startNumber];
}

final class MarkdownListItemNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  MarkdownListItemNode(super.children, {this.isChecked});

  final bool? isChecked;

  @override
  List<Object?> get props => [...super.props, isChecked];
}

enum MarkdownTableAlignment { left, center, right, none }

final class MarkdownTableNode extends MarkdownBlockParentNode<MarkdownTableRowNode> {
  MarkdownTableNode(super.children);
}

final class MarkdownTableRowNode extends MarkdownBlockParentNode<MarkdownTableCellNode> {
  MarkdownTableRowNode(super.children, {required this.isHeader});

  final bool isHeader;

  @override
  List<Object?> get props => [...super.props, isHeader];
}

final class MarkdownTableCellNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  MarkdownTableCellNode(super.children, {this.alignment = MarkdownTableAlignment.none});

  final MarkdownTableAlignment alignment;

  @override
  List<Object?> get props => [...super.props, alignment];
}

@immutable
sealed class MarkdownInlineNode extends MarkdownNode {
  const MarkdownInlineNode();
}

final class MarkdownTextNode extends MarkdownInlineNode {
  const MarkdownTextNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MarkdownCodeSpanNode extends MarkdownInlineNode {
  const MarkdownCodeSpanNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MarkdownHtmlInlineNode extends MarkdownInlineNode {
  const MarkdownHtmlInlineNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MarkdownSoftLineBreakNode extends MarkdownInlineNode {
  const MarkdownSoftLineBreakNode();
}

final class MarkdownHardLineBreakNode extends MarkdownInlineNode {
  const MarkdownHardLineBreakNode();
}

final class MarkdownMathInlineNode extends MarkdownInlineNode {
  const MarkdownMathInlineNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

@immutable
sealed class MarkdownInlineParentNode<T extends MarkdownInlineNode> extends MarkdownInlineNode {
  MarkdownInlineParentNode(Iterable<T> children) : children = List.unmodifiable(children);

  final List<T> children;

  @override
  List<Object?> get props => [...super.props, children];
}

final class MarkdownEmphasisNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownEmphasisNode(super.children);
}

final class MarkdownStrongNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownStrongNode(super.children);
}

final class MarkdownLinkNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownLinkNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [...super.props, destination, title];
}

final class MarkdownImageNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownImageNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [...super.props, destination, title];
}

final class MarkdownStrikethroughNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownStrikethroughNode(super.children);
}
