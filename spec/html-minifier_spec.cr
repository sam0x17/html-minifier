require "./spec_helper"

describe HtmlMinifier do
  it "minifies HTML" do
    html = "<html>          <head><title> yay</title></head><body> omg        \n\n\n</body></html>"
    HtmlMinifier.minify!(html).should eq "<html> <head><title> yay</title></head><body> omg </body></html>"
  end

  it "minifies CSS" do
    html = "<html><head><style>body { background-color: black; padding-left: 10px; padding-right: 10px; }</style>\n</head></html>"
    result = "<html><head><style>body{background-color:#000;padding-left:10px;padding-right:10px}</style> </head></html>"
    HtmlMinifier.minify!(html).should eq result
  end

  it "minifies Javascript" do
    html = "<html><head><script>function foo() { return 0; }</script></head></html>"
    result = "<html><head><script>function foo(){return 0}</script></head></html>"
    HtmlMinifier.minify!(html).should eq result
  end
end
