<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: .agents/skills/web-a11y-review/references/implementation-patterns.md -->
# Implementation Patterns

Use these patterns as examples. Adapt to the project's framework and style system.

## Div Or Span Used As Button

### Bad

```html
<div class="menu-toggle" onclick="openMenu()">Menu</div>
```

### Better

```html
<button class="menu-toggle" type="button" aria-expanded="false" aria-controls="site-menu">
  Menu
</button>
```

### Notes

Native buttons provide keyboard operation, focus, and role semantics. Add state such as `aria-expanded` only when it reflects real UI state.

## Link Used As Button

### Bad

```html
<a href="#" onclick="closeDialog()">閉じる</a>
```

### Better

```html
<button type="button" onclick="closeDialog()">閉じる</button>
```

Use links for navigation to another URL or fragment. Use buttons for in-place actions.

## Icon Button Without A Name

### Bad

```html
<button type="button">
  <svg aria-hidden="true"><!-- icon --></svg>
</button>
```

### Better

```html
<button type="button" aria-label="検索">
  <svg aria-hidden="true"><!-- icon --></svg>
</button>
```

Prefer visible text when space allows. Use `aria-label` for compact controls.

## Decorative Versus Meaningful Images

### Decorative

```html
<img src="/divider.png" alt="">
```

### Meaningful

```html
<img src="/chart.png" alt="2026年6月の問い合わせ数は前月比18%増加">
```

Describe the information, not the file or visual style. If the same information is already in nearby text, empty alt may be appropriate.

## Input Without Label

### Bad

```html
<input name="email" placeholder="メールアドレス">
```

### Better

```html
<label for="email">メールアドレス</label>
<input id="email" name="email" autocomplete="email">
```

Placeholder text is a hint, not a label.

## Error Text Not Associated With Input

### Bad

```html
<input id="postal-code" name="postal-code">
<p class="error">郵便番号は7桁で入力してください。</p>
```

### Better

```html
<label for="postal-code">郵便番号</label>
<input id="postal-code" name="postal-code" aria-invalid="true" aria-describedby="postal-code-error">
<p id="postal-code-error">郵便番号はハイフンなしの7桁で入力してください。</p>
```

Connect the message so assistive technologies can find it from the field.

## Focus Outline Removed

### Bad

```css
.button:focus {
  outline: none;
}
```

### Better

```css
.button:focus-visible {
  outline: 3px solid currentColor;
  outline-offset: 3px;
}
```

If the default outline does not fit the design, replace it with a visible equivalent.

## Modal Without Focus Management

### Better With Native Dialog

```html
<button type="button" id="open-help">ヘルプを開く</button>
<dialog id="help-dialog" aria-labelledby="help-title">
  <h2 id="help-title">ヘルプ</h2>
  <p>入力方法を確認できます。</p>
  <button type="button" id="close-help">閉じる</button>
</dialog>
```

```js
const dialog = document.querySelector("#help-dialog");
const opener = document.querySelector("#open-help");
const closer = document.querySelector("#close-help");

opener.addEventListener("click", () => dialog.showModal());
closer.addEventListener("click", () => dialog.close());
dialog.addEventListener("close", () => opener.focus());
```

Use a tested dialog abstraction when the project already has one.

## Hover-Only Menu

### Better

```html
<button type="button" aria-expanded="false" aria-controls="products-menu">
  製品
</button>
<ul id="products-menu" hidden>
  <li><a href="/products/a">製品A</a></li>
  <li><a href="/products/b">製品B</a></li>
</ul>
```

Keyboard and touch users need an explicit control. Keep `hidden` and `aria-expanded` synchronized.

## Tabs Without State

Use a proven tabs component when possible. If implementing manually, expose selected state, keyboard behavior, and panel relationships.

```html
<div role="tablist" aria-label="設定">
  <button role="tab" aria-selected="true" aria-controls="panel-profile" id="tab-profile">プロフィール</button>
  <button role="tab" aria-selected="false" aria-controls="panel-security" id="tab-security">セキュリティ</button>
</div>
<section role="tabpanel" id="panel-profile" aria-labelledby="tab-profile">...</section>
<section role="tabpanel" id="panel-security" aria-labelledby="tab-security" hidden>...</section>
```

## Accordion Without Button Semantics

### Better

```html
<h3>
  <button type="button" aria-expanded="false" aria-controls="faq-1">
    返品できますか
  </button>
</h3>
<div id="faq-1" hidden>
  <p>条件を満たす場合は返品できます。</p>
</div>
```

## Heading Skipped For Visual Size

### Bad

```html
<h1>サービス</h1>
<h4>料金</h4>
```

### Better

```html
<h1>サービス</h1>
<h2 class="heading-small">料金</h2>
```

Control visual size with CSS, not heading level.

## Image Text Without Alternative

If text is embedded in an image, provide equivalent adjacent text or alt text. Prefer real text for important copy so it can resize, translate, and be searched.

## Auto-Advancing Carousel

Provide pause/stop controls, avoid stealing focus, and stop nonessential motion when `prefers-reduced-motion: reduce` is active.

```css
@media (prefers-reduced-motion: reduce) {
  .carousel {
    scroll-behavior: auto;
  }
}
```

## SPA Route Change Without Title Or Focus Update

After client-side navigation, update the document title and move focus to a stable page heading or main region when appropriate. Avoid surprising focus movement for small in-page updates.
