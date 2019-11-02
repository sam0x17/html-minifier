# html-minifier

html-minifier embeds the widely-used [html-minifier](https://www.npmjs.com/package/html-minifier)
NPM package in an easy-to-use Crystal shard via [duktape.cr](https://github.com/svaarala/duktape),
which provides a fast, embedded Javascript execution environment within Crystal.

html-minifier can be used to minify arbitrary HTML content, including Javascript and/or CSS.

Some features:
* minifies HTML and any embedded CSS/Javascript within the HTML
* no non-Crystal dependencies (no Node.js or NPM required)
* all html-minifier Javascript is baked into the shard, so you won't need to package any extra files with your app/tool/library
* doesn't embed an entire Node.js runtime (Javascript is executed via duktape.cr)
* simple, Crystal-based API (`HtmlMinifier.minify!("source code")`
* full support for html-minifier [options](https://github.com/kangax/html-minifier#options-quick-reference) via `HtmlMinifier.set_options`
* sane, one-size-fits-all options are included by default (unlike html-minifier on NPM)


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     html-minifier:
       github: sam0x17/html-minifier
   ```

2. Run `shards install`

## Minification

```crystal
require "html-minifier"

HtmlMinifier.minify!("<html>  <body>minify  me!</body></html>") # => "<html> <body>minify me!</body></html>"
HtmlMinifier.minify!("<style>body { background-color: black }</style>") # => "<style>body{background-color:#000}</style>"
HtmlMinifier.minify!("<script> alert('hello world');</script>") # => "<script>alert(\"hello world\")</script>"
```

## Configuration
All options supported by html-minifier on NPM are supported by this shard. Options can be specified
by a `JSON::Any` object or by a JSON string, as shown below.

```crystal
require "html-minifier"

HtmlMinifier.minify!("<html><!-- comment --></html>") # => "<html></html>"

HtmlMinifier.set_options("{\"removeComments\": false}")

HtmlMinifier.minify!("<html><!-- comment --></html>") # => "<html><!-- comment --></html>"
```

Note that user-specified options will override their respective default values. The default
values for all options are shown below:

```json
{
  "caseSensitive": true,
  "conservativeCollapse": true,
  "minifyCSS": true,
  "minifyJS": true,
  "useShortDoctype": true,
  "removeTagWhitespace": true,
  "removeScriptTypeAttributes": true,
  "removeComments": true,
  "collapseWhitespace": true,
  "collapseInlineTagWhitespace": true,
}
```
