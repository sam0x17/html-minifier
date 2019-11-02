require "duktape"
require "json"

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
  def self.initialize_context(options_json : String? = nil)
    ctx = Duktape::Sandbox.new
    ctx.eval!(HTML_MINIFIER_JS)
    ctx.eval!(DEFAULT_OPTIONS)
    if options_json
      options_json = options_json.not_nil!
      options_json = options_json.gsub("\"", "\\\"")
      options_json = options_json.gsub("\n", "\\n")
      ctx.eval!("var user_options = JSON.parse(\"#{options_json}\")")
      ctx.eval!("for(var key in user_options) options[key] = user_options[key];")
    end
    ctx.eval!("var minify = require('html-minifier').minify;")
    ctx
  end
  @@ctx : Duktape::Sandbox? = nil

  def self.minify!(source : String)
    @@ctx ||= initialize_context
    ctx = @@ctx.not_nil!
    source = source.gsub("\n", "\\n")
    source = source.gsub("'", "\\'")
    ctx.eval!("var output = minify(\'#{source}\', options);")
    ctx.eval!("output")
    ctx.get_string(-1).not_nil!
  end

  def self.set_options(options : String)
    @@ctx = initialize_context(options)
  end

  def self.set_options(options : JSON::Any)
    @@ctx = initialize_context(options.to_json)
  end
end
