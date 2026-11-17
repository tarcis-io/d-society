import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ================================================================================
// Base Node
// ================================================================================

/// The base class for all nodes in a parsed Markdown Abstract Syntax Tree (AST).
///
/// This hierarchy is sealed so consumers (such as Flutter widget renderers) can
/// rely on exhaustive `switch` expressions across all node types.
@immutable
sealed class MarkdownNode extends Equatable {
  /// Creates a constant [MarkdownNode].
  const MarkdownNode();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => const [];
}

// ================================================================================
// Document & Structural Nodes
// ================================================================================

/// The root node of a parsed Markdown document.
///
/// Contains top-level [MarkdownBlockNode] elements. An empty document has an
/// empty [children] list.
final class MarkdownDocumentNode extends MarkdownNode {
  /// Creates a document node containing top-level block [children].
  const MarkdownDocumentNode(this.children);

  /// The top-level block nodes that make up the document.
  final List<MarkdownBlockNode> children;

  @override
  List<Object?> get props => [children];
}

/// A single item within a [MarkdownListNode].
///
/// May contain nested block elements (paragraphs, sub-lists, code blocks) or
/// be empty for blank list items (e.g., `- `).
final class MarkdownListItemNode extends MarkdownNode {
  /// Creates a list item containing block [children].
  ///
  /// Set [isChecked] to `true` or `false` for GitHub Flavored Markdown (GFM)
  /// task list items (`- [x]` / `- [ ]`), or leave `null` for standard items.
  const MarkdownListItemNode(this.children, {this.isChecked});

  /// The block nodes contained within this list item.
  final List<MarkdownBlockNode> children;

  /// The task-list checkbox state, or `null` if this is not a task item.
  final bool? isChecked;

  @override
  List<Object?> get props => [children, isChecked];
}

/// A single row within a [MarkdownTableNode].
final class MarkdownTableRowNode extends MarkdownNode {
  /// Creates a table row containing cell [children].
  const MarkdownTableRowNode(this.children);

  /// The cells in this row, ordered from left to right.
  final List<MarkdownTableCellNode> children;

  @override
  List<Object?> get props => [children];
}

/// A single cell within a [MarkdownTableRowNode].
///
/// May have an empty [children] list if the cell has no content.
final class MarkdownTableCellNode extends MarkdownNode {
  /// Creates a table cell containing inline [children].
  const MarkdownTableCellNode(this.children);

  /// The inline content rendered inside this cell.
  final List<MarkdownInlineNode> children;

  @override
  List<Object?> get props => [children];
}

// ================================================================================
// Block Nodes
// ================================================================================

/// Base class for all block-level Markdown elements.
@immutable
sealed class MarkdownBlockNode extends MarkdownNode {
  /// Creates a constant [MarkdownBlockNode].
  const MarkdownBlockNode();
}

/// A fenced or indented code block.
final class MarkdownCodeBlockNode extends MarkdownBlockNode {
  /// Creates a code block with raw [text] content.
  ///
  /// Both [language] and [infoString] must be `null` rather than empty strings
  /// when omitted.
  const MarkdownCodeBlockNode(
    this.text, {
    this.language,
    this.infoString,
  }) : assert(
         language == null || language.isNotEmpty,
         'Code block language cannot be empty; use null instead.',
       ),
       assert(
         infoString == null || infoString.isNotEmpty,
         'Code block infoString cannot be empty; use null instead.',
       );

  /// The raw source text inside the code block.
  final String text;

  /// The primary programming language identifier (e.g., `'dart'`), if specified.
  final String? language;

  /// The full raw info string following the opening fence (e.g., `'dart title="main.dart"'`).
  final String? infoString;

  @override
  List<Object?> get props => [text, language, infoString];
}

/// A horizontal rule / thematic break (`---`, `***`, or `___`).
final class MarkdownThematicBreakNode extends MarkdownBlockNode {
  /// Creates a thematic break node.
  const MarkdownThematicBreakNode();
}

/// A block of raw HTML markup.
final class MarkdownHtmlBlockNode extends MarkdownBlockNode {
  /// Creates a raw HTML block with non-empty [text].
  const MarkdownHtmlBlockNode(this.text) : assert(text.isNotEmpty, 'HTML block text cannot be empty.');

  /// The raw HTML source string.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// Horizontal text alignment for a column in a [MarkdownTableNode].
enum MarkdownTableAlignment {
  /// Left-aligned column (`:---`).
  left,

  /// Center-aligned column (`:---:`).
  center,

  /// Right-aligned column (`---:`).
  right,

  /// No explicit alignment specified (`---`).
  none,
}

/// A GitHub Flavored Markdown (GFM) table.
final class MarkdownTableNode extends MarkdownBlockNode {
  /// Creates a table node with column definitions, a [headerRow], and [bodyRows].
  ///
  /// Requires at least one column and matching column counts between
  /// [columnAlignments] and [headerRow].
  const MarkdownTableNode({
    required this.columnAlignments,
    required this.headerRow,
    required this.bodyRows,
  }) : assert(
         columnAlignments.length > 0,
         'Table must have at least one column.',
       ),
       assert(
         headerRow.children.length == columnAlignments.length,
         'Header cell count must match columnAlignments length.',
       );

  /// The alignment specification for each column in the table.
  final List<MarkdownTableAlignment> columnAlignments;

  /// The header row rendered at the top of the table.
  final MarkdownTableRowNode headerRow;

  /// The data rows rendered below [headerRow].
  final List<MarkdownTableRowNode> bodyRows;

  @override
  List<Object?> get props => [columnAlignments, headerRow, bodyRows];
}

/// A display-mode math block (e.g., delimited by `$$ ... $$` or `\[ ... \]`).
final class MarkdownMathBlockNode extends MarkdownBlockNode {
  /// Creates a display math block containing raw TeX/LaTeX [text].
  const MarkdownMathBlockNode(this.text);

  /// The raw mathematical expression without surrounding delimiters.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// Serialization format used by a [MarkdownFrontmatterNode].
enum MarkdownFrontmatterFormat {
  /// YAML frontmatter delimited by `---`.
  yaml,

  /// TOML frontmatter delimited by `+++`.
  toml,

  /// JSON frontmatter delimited by `;;;`.
  json,

  /// An unrecognized or custom frontmatter format.
  unknown,
}

/// Document-level metadata block appearing at the start of a Markdown file.
final class MarkdownFrontmatterNode extends MarkdownBlockNode {
  /// Creates a frontmatter node with raw [text] and an optional [format].
  const MarkdownFrontmatterNode(
    this.text, {
    this.format = MarkdownFrontmatterFormat.yaml,
  });

  /// The raw metadata content without surrounding delimiters.
  final String text;

  /// The markup format of [text].
  final MarkdownFrontmatterFormat format;

  @override
  List<Object?> get props => [text, format];
}

/// Base class for block nodes that contain child nodes of type [T].
@immutable
sealed class MarkdownBlockParentNode<T extends MarkdownNode> extends MarkdownBlockNode {
  /// Creates a parent block node with [children].
  const MarkdownBlockParentNode(this.children);

  /// The child nodes contained within this block.
  final List<T> children;

  @override
  List<Object?> get props => [children];
}

/// A standard paragraph block containing inline elements.
final class MarkdownParagraphNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  /// Creates a paragraph node with non-empty inline [children].
  const MarkdownParagraphNode(super.children) : assert(children.length > 0, 'Paragraph cannot be empty.');
}

/// An ATX (`#`) or Setext (`===` / `---`) section heading.
///
/// Empty headings (such as `# `) validly contain an empty [children] list.
final class MarkdownHeadingNode extends MarkdownBlockParentNode<MarkdownInlineNode> {
  /// Creates a heading node with inline [children] and a [level] from `1` to `6`.
  const MarkdownHeadingNode(
    super.children, {
    required this.level,
    this.id,
  }) : assert(
         level >= 1 && level <= 6,
         'Heading level must be between 1 and 6.',
       ),
       assert(
         id == null || id.isNotEmpty,
         'Heading id cannot be empty; use null instead.',
       );

  /// The heading depth from `1` (`<h1>`) to `6` (`<h6>`).
  final int level;

  /// An optional anchor slug or custom heading ID (e.g., from `{#custom-id}`).
  final String? id;

  @override
  List<Object?> get props => [children, level, id];
}

/// A block quote (`> ...`) containing nested block elements.
///
/// Empty block quotes (`>`) validly contain an empty [children] list.
final class MarkdownBlockQuoteNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  /// Creates a block quote node containing block [children].
  const MarkdownBlockQuoteNode(super.children);
}

/// An ordered or unordered list containing [MarkdownListItemNode] entries.
final class MarkdownListNode extends MarkdownBlockParentNode<MarkdownListItemNode> {
  /// Creates a list node with at least one [MarkdownListItemNode].
  const MarkdownListNode(
    super.children, {
    required this.isOrdered,
    this.startNumber,
    this.isTight = true,
    this.delimiter,
  }) : assert(
         children.length > 0,
         'List must contain at least one item.',
       ),
       assert(
         isOrdered || startNumber == null,
         'Unordered lists cannot have a startNumber.',
       ),
       assert(
         startNumber == null || (startNumber >= 0 && startNumber <= 999999999),
         'Ordered list startNumber must be between 0 and 999999999.',
       ),
       assert(
         delimiter == null || delimiter.isNotEmpty,
         'List delimiter cannot be empty; use null instead.',
       );

  /// Whether the list is numbered (`true`) or bulleted (`false`).
  final bool isOrdered;

  /// The starting index of an ordered list, or `null` for unordered lists.
  final int? startNumber;

  /// Whether items are rendered tightly without inter-item paragraph spacing.
  ///
  /// In CommonMark, a list is loose (`false`) if any of its items are separated
  /// by blank lines or contain multiple block elements separated by a blank line.
  final bool isTight;

  /// The list marker character used in the source (e.g., `'-'`, `'*'`, `'.'`, `')'`).
  final String? delimiter;

  @override
  List<Object?> get props => [
    children,
    isOrdered,
    startNumber,
    isTight,
    delimiter,
  ];
}

/// A footnote definition block (`[^id]: ...`) referenced by [MarkdownFootnoteReferenceNode].
final class MarkdownFootnoteDefinitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  /// Creates a footnote definition with a non-empty [identifier].
  const MarkdownFootnoteDefinitionNode(
    super.children, {
    required this.identifier,
    this.index,
  }) : assert(
         identifier.isNotEmpty,
         'Footnote identifier cannot be empty.',
       ),
       assert(
         index == null || index >= 1,
         'Footnote index must be 1 or greater.',
       );

  /// The raw footnote label from the source (e.g., `'1'` or `'my-note'`).
  final String identifier;

  /// The resolved 1-based sequential display number assigned during parsing.
  final int? index;

  @override
  List<Object?> get props => [children, identifier, index];
}

/// Semantic category of a [MarkdownAdmonitionNode] callout block.
enum MarkdownAdmonitionType {
  /// General informational note (`[!NOTE]`).
  note,

  /// Helpful tip or best practice (`[!TIP]`).
  tip,

  /// Key information users should not miss (`[!IMPORTANT]`).
  important,

  /// Potential pitfall or warning (`[!WARNING]`).
  warning,

  /// High-risk action or critical caution (`[!CAUTION]`).
  caution,

  /// Supplementary info callout (`[!INFO]`).
  info,

  /// Positive outcome or success callout (`[!SUCCESS]`).
  success,

  /// Error or destructive-action callout (`[!DANGER]`).
  danger,

  /// Any unrecognized admonition type (see [MarkdownAdmonitionNode.rawType]).
  unknown,
}

/// A callout / admonition block (e.g., GitHub `> [!NOTE]` or Obsidian callouts).
final class MarkdownAdmonitionNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  /// Creates an admonition node with block [children] and a semantic [type].
  const MarkdownAdmonitionNode(
    super.children, {
    required this.type,
    this.title,
    this.rawType,
    this.isCollapsible = false,
    this.isInitiallyExpanded,
  }) : assert(
         title == null || title.isNotEmpty,
         'Admonition title cannot be empty; use null instead.',
       ),
       assert(
         rawType == null || rawType.isNotEmpty,
         'Admonition rawType cannot be empty; use null instead.',
       ),
       assert(
         isCollapsible || isInitiallyExpanded == null,
         'isInitiallyExpanded can only be set when isCollapsible is true.',
       );

  /// The normalized semantic type of the callout.
  final MarkdownAdmonitionType type;

  /// An optional custom title overriding the default label for [type].
  final String? title;

  /// The original unnormalized type tag from the source (useful when [type] is [MarkdownAdmonitionType.unknown]).
  final String? rawType;

  /// Whether the callout can be collapsed/expanded by the user (e.g., `[!NOTE]-` or `[!NOTE]+`).
  final bool isCollapsible;

  /// Initial expansion state when [isCollapsible] is `true`, or `null` if not collapsible.
  final bool? isInitiallyExpanded;

  @override
  List<Object?> get props => [
    children,
    type,
    title,
    rawType,
    isCollapsible,
    isInitiallyExpanded,
  ];
}

/// A collapsible HTML disclosure block (`<details><summary>...</summary>...</details>`).
final class MarkdownDetailsNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  /// Creates a details block with block [children] and an optional [summary].
  const MarkdownDetailsNode(
    super.children, {
    this.summary = const [],
    this.isInitiallyExpanded = false,
  });

  /// The inline content of the `<summary>` header.
  final List<MarkdownInlineNode> summary;

  /// Whether the HTML `open` attribute was present on `<details>`.
  final bool isInitiallyExpanded;

  @override
  List<Object?> get props => [children, summary, isInitiallyExpanded];
}

/// A collapsible reasoning block emitted by thinking LLMs (`<think>...</think>`).
///
/// May contain an empty [children] list while the opening `<think>` tag has
/// just arrived during token streaming.
final class MarkdownThinkingNode extends MarkdownBlockParentNode<MarkdownBlockNode> {
  /// Creates a thinking block containing parsed block [children].
  const MarkdownThinkingNode(
    super.children, {
    this.isComplete = true,
  });

  /// Whether the closing `</think>` tag has been received during streaming.
  final bool isComplete;

  @override
  List<Object?> get props => [children, isComplete];
}

// ================================================================================
// Inline Nodes
// ================================================================================

/// Base class for all inline-level Markdown elements.
@immutable
sealed class MarkdownInlineNode extends MarkdownNode {
  /// Creates a constant [MarkdownInlineNode].
  const MarkdownInlineNode();
}

/// A run of plain, unformatted text.
final class MarkdownTextNode extends MarkdownInlineNode {
  /// Creates a text node with non-empty [text].
  const MarkdownTextNode(this.text) : assert(text.isNotEmpty, 'Text node cannot be empty.');

  /// The plain text content.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// An inline code span (e.g., `` `code` ``).
///
/// May contain empty or whitespace-only [text] depending on backtick delimiter rules.
final class MarkdownCodeSpanNode extends MarkdownInlineNode {
  /// Creates an inline code span node with [text].
  const MarkdownCodeSpanNode(this.text);

  /// The raw code content with outer backticks stripped.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// An inline raw HTML tag (e.g., `<span>`, `<kbd>`, or `<br>`).
final class MarkdownHtmlInlineNode extends MarkdownInlineNode {
  /// Creates an inline HTML node with non-empty [text].
  const MarkdownHtmlInlineNode(this.text) : assert(text.isNotEmpty, 'Inline HTML cannot be empty.');

  /// The raw inline HTML markup.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// A soft line break (a single newline within a paragraph), typically rendered as a space.
final class MarkdownSoftLineBreakNode extends MarkdownInlineNode {
  /// Creates a soft line break node.
  const MarkdownSoftLineBreakNode();
}

/// A hard line break (two trailing spaces or a trailing `\` before a newline).
final class MarkdownHardLineBreakNode extends MarkdownInlineNode {
  /// Creates a hard line break node.
  const MarkdownHardLineBreakNode();
}

/// An inline footnote reference marker (e.g., `[^1]`) linking to a [MarkdownFootnoteDefinitionNode].
final class MarkdownFootnoteReferenceNode extends MarkdownInlineNode {
  /// Creates a footnote reference with a non-empty [identifier].
  const MarkdownFootnoteReferenceNode(
    this.identifier, {
    this.index,
  }) : assert(
         identifier.isNotEmpty,
         'Footnote identifier cannot be empty.',
       ),
       assert(
         index == null || index >= 1,
         'Footnote index must be 1 or greater.',
       );

  /// The raw footnote label matching [MarkdownFootnoteDefinitionNode.identifier].
  final String identifier;

  /// The resolved 1-based sequential display number assigned during parsing.
  final int? index;

  @override
  List<Object?> get props => [identifier, index];
}

/// An inline math expression (e.g., delimited by `$ ... $` or `\( ... \)`).
final class MarkdownMathInlineNode extends MarkdownInlineNode {
  /// Creates an inline math node with non-empty [text].
  const MarkdownMathInlineNode(this.text) : assert(text.isNotEmpty, 'Inline math expression cannot be empty.');

  /// The raw mathematical expression without surrounding delimiters.
  final String text;

  @override
  List<Object?> get props => [text];
}

/// An inline source citation badge emitted by RAG or search-grounded LLMs.
final class MarkdownCitationNode extends MarkdownInlineNode {
  /// Creates a citation badge with a non-empty [identifier].
  const MarkdownCitationNode(
    this.identifier, {
    this.index,
    this.title,
    this.destination,
  }) : assert(
         identifier.isNotEmpty,
         'Citation identifier cannot be empty.',
       ),
       assert(
         index == null || index >= 1,
         'Citation index must be 1 or greater.',
       ),
       assert(
         title == null || title.isNotEmpty,
         'Citation title cannot be empty; use null instead.',
       ),
       assert(
         destination == null || destination.isNotEmpty,
         'Citation destination cannot be empty; use null instead.',
       );

  /// The raw citation key or chunk ID from the model output.
  final String identifier;

  /// The 1-based sequential badge number displayed in the UI.
  final int? index;

  /// Optional display title of the cited source or document.
  final String? title;

  /// Optional URL or deep link to the underlying source.
  final String? destination;

  @override
  List<Object?> get props => [identifier, index, title, destination];
}

/// Base class for inline nodes that wrap child [MarkdownInlineNode] elements.
@immutable
sealed class MarkdownInlineParentNode extends MarkdownInlineNode {
  /// Creates a parent inline node with [children].
  const MarkdownInlineParentNode(this.children);

  /// The nested inline nodes contained within this element.
  final List<MarkdownInlineNode> children;

  @override
  List<Object?> get props => [children];
}

/// Italicized / emphasized inline text (`*text*` or `_text_`).
final class MarkdownEmphasisNode extends MarkdownInlineParentNode {
  /// Creates an emphasis node with non-empty inline [children].
  const MarkdownEmphasisNode(super.children) : assert(children.length > 0, 'Emphasis node cannot be empty.');
}

/// Bold / strongly emphasized inline text (`**text**` or `__text__`).
final class MarkdownStrongNode extends MarkdownInlineParentNode {
  /// Creates a strong emphasis node with non-empty inline [children].
  const MarkdownStrongNode(super.children) : assert(children.length > 0, 'Strong node cannot be empty.');
}

/// A hyperlink (`[label](destination "title")`).
///
/// Both [children] (e.g., `[](url)`) and [title] (e.g., `[text](url "")`) may
/// validly be empty per the CommonMark specification.
final class MarkdownLinkNode extends MarkdownInlineParentNode {
  /// Creates a hyperlink node pointing to [destination].
  const MarkdownLinkNode(
    super.children, {
    required this.destination,
    this.title,
  });

  /// The target URL or relative path of the link.
  final String destination;

  /// An optional advisory title (tooltip) for the link.
  final String? title;

  @override
  List<Object?> get props => [children, destination, title];
}

/// An embedded image (`![alt](destination "title")`).
///
/// The [children] list represents the image's alt text and may validly be empty
/// (`![](url)`).
final class MarkdownImageNode extends MarkdownInlineParentNode {
  /// Creates an image node pointing to [destination].
  const MarkdownImageNode(
    super.children, {
    required this.destination,
    this.title,
    this.width,
    this.height,
  }) : assert(
         width == null || width > 0,
         'Image width must be greater than 0.',
       ),
       assert(
         height == null || height > 0,
         'Image height must be greater than 0.',
       );

  /// The source URL or asset path of the image.
  final String destination;

  /// An optional advisory title (tooltip) for the image.
  final String? title;

  /// Optional explicit display width in logical pixels (from extended image syntax).
  final double? width;

  /// Optional explicit display height in logical pixels (from extended image syntax).
  final double? height;

  @override
  List<Object?> get props => [children, destination, title, width, height];
}

/// Strikethrough text (`~~text~~`).
final class MarkdownStrikethroughNode extends MarkdownInlineParentNode {
  /// Creates a strikethrough node with non-empty inline [children].
  const MarkdownStrikethroughNode(super.children) : assert(children.length > 0, 'Strikethrough node cannot be empty.');
}

/// Highlighted / marked text (`==text==`).
final class MarkdownHighlightNode extends MarkdownInlineParentNode {
  /// Creates a highlight node with non-empty inline [children].
  const MarkdownHighlightNode(super.children) : assert(children.length > 0, 'Highlight node cannot be empty.');
}

/// Subscript text (`~text~`).
final class MarkdownSubscriptNode extends MarkdownInlineParentNode {
  /// Creates a subscript node with non-empty inline [children].
  const MarkdownSubscriptNode(super.children) : assert(children.length > 0, 'Subscript node cannot be empty.');
}

/// Superscript text (`^text^`).
final class MarkdownSuperscriptNode extends MarkdownInlineParentNode {
  /// Creates a superscript node with non-empty inline [children].
  const MarkdownSuperscriptNode(super.children) : assert(children.length > 0, 'Superscript node cannot be empty.');
}
