# Tengo for Zed

[Tengo](https://github.com/d5/tengo) language support for the
[Zed](https://zed.dev) editor: syntax highlighting, code structure, and full
IDE features powered by [`tengo-lsp`](https://github.com/popoffvg/tengo-lsp).

## Features

- **Syntax highlighting**, brackets, indentation and **outline** via a
  Tree-sitter grammar ([`tree-sitter-tengo`](https://github.com/popoffvg/tree-sitter-tengo)).
- **Language server** features through `tengo-lsp`:
  - go to definition — imports, import aliases, `alias.member` → the matching
    `export { ... }` key, and SDK artifact calls (`getTemplateId`,
    `importTemplate`, `importSoftware`, `importAsset`, `getSoftwareInfo`);
  - **find all references** across the workspace for exported module members
    (every `alias.member` usage plus references inside the defining module);
  - member completion after `.` on imported aliases;
  - hover with signature and doc comments (`//` and `/** */`);
  - **formatting** — reindents with hard tabs (one level per enclosing
    `{}`/`[]`/`()`) and strips trailing whitespace; comments are preserved and
    code is never reflowed (requires `tengo-lsp` ≥ v0.2.0).
- Platforma-style **import resolution**: local `:artifact` ids against the
  package `src/`, and `pkg:artifact` ids via `node_modules`, including the
  published `dist/tengo/{lib,software,asset}` layout.

## Installation

### From the Zed extension registry

Open the command palette → **zed: extensions**, search for **Tengo**, and
install it.

### As a dev extension (from source)

1. Clone this repository.
2. In Zed: command palette → **zed: install dev extension** → select the
   cloned directory. Zed compiles the extension (and downloads the grammar)
   automatically.

### Language server

The extension obtains `tengo-lsp` automatically:

1. if a `tengo-lsp` binary is found on your `PATH`, it is used as-is;
2. otherwise the matching release binary is **downloaded** from
   [`popoffvg/tengo-lsp`](https://github.com/popoffvg/tengo-lsp/releases) and
   cached by Zed.

No manual server setup is required. To use a local build, put your `tengo-lsp`
on `PATH` (e.g. `~/.local/bin`).

> On macOS (Apple Silicon), if you replace the binary by copying it, re-sign it
> with `codesign --force --sign - <path>` — otherwise the OS may kill the
> unsigned copy on launch.

### Formatting

Works out of the box — no configuration. `tengo-lsp` advertises
`textDocument/formatting`, and Zed's defaults (`"format_on_save": "on"`,
`"formatter": "auto"`) route Tengo through it: there is no Prettier for Tengo,
so `auto` falls back to the language server. **Format Document**
(`editor: format`) and format-on-save just work, and the extension sets
`hard_tabs` so manual edits already match the formatter's tab output.

To force the language server explicitly (e.g. if you've changed the global
defaults), add to `settings.json`:

```json
{ "languages": { "Tengo": { "formatter": "language_server" } } }
```

## Versioning

This extension tracks the `tengo-lsp` releases it downloads. The grammar is
pinned by commit in [`extension.toml`](extension.toml) under `[grammars.tengo]`.

## Development

```bash
cargo build --release --target wasm32-wasip1   # build the extension wasm
```

Then load the directory as a dev extension (see above). Edit the language data
under `languages/tengo/` (`config.toml`, `highlights.scm`, `brackets.scm`,
`indents.scm`, `outline.scm`) and the server glue in `src/lib.rs`.

## License

MIT
