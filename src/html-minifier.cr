require "duktape"

HTML_MINIFIER_JS = {{read_file("html-minifier/html-minifier.min.js")}}

DEFAULT_OPTIONS = <<-JS
  var options = {
    caseSensitive: true,
    conservativeCollapse: true,
    minifyCSS: true,
    minifyJS: true,
    useShortDoctype: true,
    removeTagWhitespace: true,
    removeScriptTypeAttributes: true,
    removeComments: true,
    collapseWhitespace: true,
    collapseInlineTagWhitespace: true,
  }
JS


module HtmlMinifier
  def self.initialize_context
    ctx = Duktape::Sandbox.new
    ctx.eval!(HTML_MINIFIER_JS)
    ctx.eval!(DEFAULT_OPTIONS)
    ctx.eval!("var minify = require('html-minifier').minify;")
    ctx
  end
  @@ctx : Duktape::Sandbox? = nil

  def self.minify!(source : String)
    @@ctx ||= initialize_context
    ctx = @@ctx.not_nil!
    source = source.gsub("\"", "\\\"")
    source = source.gsub("\n", "\\n")
    source = source.gsub("'", "\\'")
    ctx.eval!("var output = minify(\'#{source}\', options);")
    ctx.eval!("output")
    ctx.get_string(-1).not_nil!
  end
end
