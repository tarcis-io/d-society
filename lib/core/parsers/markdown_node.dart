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

enum MarkdownTableAlignment { left, center, right, none }

final class MarkdownTableNode extends MarkdownBlockNode {
  MarkdownTableNode({
    required Iterable<MarkdownTableAlignment> columnAlignments,
    required this.headerRow,
    required Iterable<MarkdownTableRowNode> bodyRows,
  }) : columnAlignments = List.unmodifiable(columnAlignments),
       bodyRows = List.unmodifiable(bodyRows);

  final List<MarkdownTableAlignment> columnAlignments;
  final MarkdownTableRowNode headerRow;
  final List<MarkdownTableRowNode> bodyRows;

  @override
  List<Object?> get props => [...super.props, columnAlignments, headerRow, bodyRows];
}

final class MarkdownMathBlockNode extends MarkdownBlockNode {
  const MarkdownMathBlockNode(this.text);

  final String text;

  @override
  List<Object?> get props => [...super.props, text];
}

final class MarkdownFrontmatterNode extends MarkdownBlockNode {
  const MarkdownFrontmatterNode(this.text);

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

final class MarkdownTableRowNode extends MarkdownBlockParentNode<MarkdownTableCellNode> {
  MarkdownTableRowNode(super.children);
}

final class MarkdownTableCellNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  MarkdownTableCellNode(super.children);
}

final class MarkdownFootnoteDefinitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  MarkdownFootnoteDefinitionNode(super.children, {required this.identifier});

  final String identifier;

  @override
  List<Object?> get props => [...super.props, identifier];
}

enum MarkdownAdmonitionType { note, warning, tip }

final class MarkdownAdmonitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  MarkdownAdmonitionNode(super.children, {required this.type, this.title});

  final MarkdownAdmonitionType type;
  final String? title;

  @override
  List<Object?> get props => [...super.props, type, title];
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

final class MarkdownFootnoteReferenceNode extends MarkdownInlineNode {
  const MarkdownFootnoteReferenceNode(this.identifier);

  final String identifier;

  @override
  List<Object?> get props => [...super.props, identifier];
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

final class MarkdownHighlightNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownHighlightNode(super.children);
}

final class MarkdownSubscriptNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownSubscriptNode(super.children);
}

final class MarkdownSuperscriptNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  MarkdownSuperscriptNode(super.children);
}
