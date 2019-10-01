require "duktape"
require "baked_file_system"

class HtmlMinifierNpm
  extend BakedFileSystem
  bake_folder "../html-minifier"
end
HTML_MINIFIER_JS = HtmlMinifierNpm.get("html-minifier.min.js").gets_to_end


module HtmlMinifier

end
