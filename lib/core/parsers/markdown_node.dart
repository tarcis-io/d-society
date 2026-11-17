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
  List<Object?> get props => [text, language];
}

final class MarkdownThematicBreakNode extends MarkdownBlockNode {
  const MarkdownThematicBreakNode();
}

final class MarkdownHtmlBlockNode extends MarkdownBlockNode {
  const MarkdownHtmlBlockNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

enum MarkdownTableAlignment { left, center, right, none }

final class MarkdownTableNode extends MarkdownBlockNode {
  const MarkdownTableNode(this.columnAlignments, this.headerRow, this.bodyRows);

  final List<MarkdownTableAlignment> columnAlignments;
  final MarkdownTableRowNode headerRow;
  final List<MarkdownTableRowNode> bodyRows;

  @override
  List<Object?> get props => [columnAlignments, headerRow, bodyRows];
}

final class MarkdownMathBlockNode extends MarkdownBlockNode {
  const MarkdownMathBlockNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class MarkdownFrontmatterNode extends MarkdownBlockNode {
  const MarkdownFrontmatterNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

@immutable
sealed class MarkdownBlockParentNode<T extends MarkdownNode> extends MarkdownBlockNode {
  const MarkdownBlockParentNode(this.children);

  final List<T> children;

  @override
  List<Object?> get props => [...super.props, children];
}

final class MarkdownDocumentNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownDocumentNode(super.children);
}

final class MarkdownParagraphNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  const MarkdownParagraphNode(super.children);
}

final class MarkdownHeadingNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  const MarkdownHeadingNode(super.children, {required this.level});

  final int level;

  @override
  List<Object?> get props => [...super.props, level];
}

final class MarkdownBlockQuoteNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownBlockQuoteNode(super.children);
}

final class MarkdownListNode extends MarkdownBlockParentNode<MarkdownListItemNode> {
  const MarkdownListNode(super.children, {required this.isOrdered, this.startNumber});

  final bool isOrdered;
  final int? startNumber;

  @override
  List<Object?> get props => [...super.props, isOrdered, startNumber];
}

final class MarkdownListItemNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownListItemNode(super.children, {this.isChecked});

  final bool? isChecked;

  @override
  List<Object?> get props => [...super.props, isChecked];
}

final class MarkdownTableRowNode extends MarkdownBlockParentNode<MarkdownTableCellNode> {
  const MarkdownTableRowNode(super.children);
}

final class MarkdownTableCellNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  const MarkdownTableCellNode(super.children);
}

final class MarkdownFootnoteDefinitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownFootnoteDefinitionNode(super.children, {required this.identifier});

  final String identifier;

  @override
  List<Object?> get props => [...super.props, identifier];
}

enum MarkdownAdmonitionType { note, tip, important, warning, caution, info, success, danger, unknown }

final class MarkdownAdmonitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownAdmonitionNode(super.children, {required this.type, this.title});

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
  List<Object?> get props => [text];
}

final class MarkdownCodeSpanNode extends MarkdownInlineNode {
  const MarkdownCodeSpanNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class MarkdownHtmlInlineNode extends MarkdownInlineNode {
  const MarkdownHtmlInlineNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
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
  List<Object?> get props => [identifier];
}

final class MarkdownMathInlineNode extends MarkdownInlineNode {
  const MarkdownMathInlineNode(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

@immutable
sealed class MarkdownInlineParentNode<T extends MarkdownInlineNode> extends MarkdownInlineNode {
  const MarkdownInlineParentNode(this.children);

  final List<T> children;

  @override
  List<Object?> get props => [...super.props, children];
}

final class MarkdownEmphasisNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownEmphasisNode(super.children);
}

final class MarkdownStrongNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownStrongNode(super.children);
}

final class MarkdownLinkNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownLinkNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [...super.props, destination, title];
}

final class MarkdownImageNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownImageNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [...super.props, destination, title];
}

final class MarkdownStrikethroughNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownStrikethroughNode(super.children);
}

final class MarkdownHighlightNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownHighlightNode(super.children);
}

final class MarkdownSubscriptNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownSubscriptNode(super.children);
}

final class MarkdownSuperscriptNode extends MarkdownInlineParentNode<MarkdownInlineNode> {
  const MarkdownSuperscriptNode(super.children);
}
