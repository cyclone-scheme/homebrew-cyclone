class CycloneBootstrap < Formula
  desc ":cyclone-bootstrap: R7RS Scheme compiler used to bootstrap the cyclone R7RS Scheme compiler"
  homepage "http://justinethier.github.io/cyclone/"
  url "https://github.com/justinethier/cyclone-bootstrap/archive/v0.35.0.tar.gz"
  sha256 "9bcd86896c2b8f2dc873411c6ec93360c538f7e92dc5632abb3711a61bd2e2cb"
  version "v0.35.0"
  depends_on "git"
  depends_on "gcc"
  depends_on "ck"
  depends_on "cyclone-bootstrap"

  def install_cyclone_lib_files
    lib.mkdir
    libexec.install %w[libs]
    share.mkdir
    mkdir share/"cyclone"
    mkdir share/"cyclone/cyclone"
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.o"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.so"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.sld"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.scm"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.meta"]      
  end

  def install_cyclone_files
    bin.mkdir
    include.mkdir
    libexec.install %w[scheme srfi include]
    mkdir libexec/"bin"
    (libexec/"bin").install "cyclone"
    (libexec/"bin").install "icyc"
    (libexec/"bin").install "winds"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mkdir libexec/"lib"
    (libexec/"lib").install "libcyclone.a"
    (libexec/"lib").install "libcyclonebn.a"
    lib.install_symlink Dir["#{libexec}/lib/*"]
    mkdir include/"cyclone"
    (include/"cyclone").install_symlink Dir["#{libexec}/include/cyclone/*.h"]
    mkdir share/"cyclone/scheme"
    mkdir share/"cyclone/scheme/cyclone"
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.o"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.so"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.scm"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.meta"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.o"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.so"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.sld"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.scm"]
    mkdir share/"cyclone/srfi"
    (share/"cyclone/srfi").install_symlink Dir["#{libexec}/srfi/*.sld"]
    (share/"cyclone/srfi").install_symlink Dir["#{libexec}/srfi/*.scm"]
    mkdir share/"cyclone/srfi/list-queues"
    (share/"cyclone/srfi/list-queues").install_symlink Dir["#{libexec}/srfi/list-queues/*.scm"]
    mkdir share/"cyclone/srfi/sorting"
    (share/"cyclone/srfi/sorting").install_symlink Dir["#{libexec}/srfi/sorting/*.scm"]
    mkdir share/"cyclone/srfi/sets"
    (share/"cyclone/srfi/sets").install_symlink Dir["#{libexec}/srfi/sets/*.scm"]
    (share/"cyclone/srfi").install_symlink Dir["#{libexec}/srfi/*.meta"]
    (share/"cyclone/srfi").install_symlink Dir["#{libexec}/srfi/*.o"]
    (share/"cyclone/srfi").install_symlink Dir["#{libexec}/srfi/*.so"]
  end

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", "/usr/local/bin"
    system "make"
    install_cyclone_lib_files 
    install_cyclone_files
  end

  test do
      system "make test"
  end
end
