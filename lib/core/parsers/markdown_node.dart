import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ================================================================================
// Markdown Node
// ================================================================================

@immutable
sealed class MarkdownNode extends Equatable {
  const MarkdownNode();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

// ================================================================================
// Document & Structural Nodes
// ================================================================================

final class MarkdownDocumentNode extends MarkdownNode {
  const MarkdownDocumentNode(this.children);

  final List<MarkdownBlockNode> children;

  @override
  List<Object?> get props => [children];
}

final class MarkdownListItemNode extends MarkdownNode {
  const MarkdownListItemNode(this.children, {this.isChecked});

  final List<MarkdownBlockNode> children;
  final bool? isChecked;

  @override
  List<Object?> get props => [children, isChecked];
}

final class MarkdownTableRowNode extends MarkdownNode {
  const MarkdownTableRowNode(this.children);

  final List<MarkdownTableCellNode> children;

  @override
  List<Object?> get props => [children];
}

final class MarkdownTableCellNode extends MarkdownNode {
  const MarkdownTableCellNode(this.children);

  final List<MarkdownInlineNode> children;

  @override
  List<Object?> get props => [children];
}

// ================================================================================
// Block Nodes
// ================================================================================

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
  const MarkdownTableNode({required this.columnAlignments, required this.headerRow, required this.bodyRows});

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
  List<Object?> get props => [children];
}

final class MarkdownParagraphNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  const MarkdownParagraphNode(super.children);
}

final class MarkdownHeadingNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  const MarkdownHeadingNode(super.children, {required this.level});

  final int level;

  @override
  List<Object?> get props => [children, level];
}

final class MarkdownBlockQuoteNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownBlockQuoteNode(super.children);
}

final class MarkdownListNode extends MarkdownBlockParentNode<MarkdownListItemNode> {
  const MarkdownListNode(super.children, {required this.isOrdered, this.startNumber});

  final bool isOrdered;
  final int? startNumber;

  @override
  List<Object?> get props => [children, isOrdered, startNumber];
}

final class MarkdownFootnoteDefinitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownFootnoteDefinitionNode(super.children, {required this.identifier});

  final String identifier;

  @override
  List<Object?> get props => [children, identifier];
}

enum MarkdownAdmonitionType {
  note,
  tip,
  important,
  warning,
  caution,
  info,
  success,
  danger,
  unknown,
}

final class MarkdownAdmonitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  const MarkdownAdmonitionNode(super.children, {required this.type, this.title});

  final MarkdownAdmonitionType type;
  final String? title;

  @override
  List<Object?> get props => [children, type, title];
}

// ================================================================================
// Inline Nodes
// ================================================================================

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
sealed class MarkdownInlineParentNode extends MarkdownInlineNode {
  const MarkdownInlineParentNode(this.children);

  final List<MarkdownInlineNode> children;

  @override
  List<Object?> get props => [children];
}

final class MarkdownEmphasisNode extends MarkdownInlineParentNode {
  const MarkdownEmphasisNode(super.children);
}

final class MarkdownStrongNode extends MarkdownInlineParentNode {
  const MarkdownStrongNode(super.children);
}

final class MarkdownLinkNode extends MarkdownInlineParentNode {
  const MarkdownLinkNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [children, destination, title];
}

final class MarkdownImageNode extends MarkdownInlineParentNode {
  const MarkdownImageNode(super.children, {required this.destination, this.title});

  final String destination;
  final String? title;

  @override
  List<Object?> get props => [children, destination, title];
}

final class MarkdownStrikethroughNode extends MarkdownInlineParentNode {
  const MarkdownStrikethroughNode(super.children);
}

final class MarkdownHighlightNode extends MarkdownInlineParentNode {
  const MarkdownHighlightNode(super.children);
}

final class MarkdownSubscriptNode extends MarkdownInlineParentNode {
  const MarkdownSubscriptNode(super.children);
}

final class MarkdownSuperscriptNode extends MarkdownInlineParentNode {
  const MarkdownSuperscriptNode(super.children);
}
