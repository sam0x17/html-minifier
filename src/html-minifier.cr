require "duktape"
require "baked_file_system"

class HtmlMinifierNpm
  extend BakedFileSystem
  bake_folder "../html-minifier"
end

HTML_MINIFIER_JS = HtmlMinifierNpm.get("html-minifier.min.js").gets_to_end

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
  @@ctx : Duktape::Sandbox = initialize_context

  def self.minify!(source : String)
    source = source.gsub("\"", "\\\"")
    source = source.gsub("\n", "\\n")
    source = source.gsub("'", "\\'")
    @@ctx.eval!("var output = minify(\'#{source}\', options);")
    @@ctx.eval!("output")
    @@ctx.get_string(-1).not_nil!
  end
end

puts HtmlMinifier.minify!("<html>          <head><title> yay</title></head><body> omg        \n\n\n</body></html>")
