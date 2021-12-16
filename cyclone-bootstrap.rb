class CycloneBootstrap < Formula
  desc ":cyclone-bootstrap: R7RS Scheme compiler used to bootstrap the cyclone R7RS Scheme compiler"
  homepage "http://justinethier.github.io/cyclone/"
  url "https://github.com/justinethier/cyclone-bootstrap/archive/v0.32.0.tar.gz"
  sha256 "551f0c23c73c0c51b941bcdb7697805b73c75401277262958e47013bfcd7b952"
  version "v0.32.0"
  depends_on "git"
  depends_on "gcc"
  depends_on "ck"
  depends_on "cyclone-bootstrap"

  def install_cyclone_lib_files
    lib.mkdir
    libexec.install %w[libs]
    share.mkdir
    mkdir share/"cyclone"
    mkdir share/"cyclone/libs"
    (share/"cyclone/libs").install_symlink Dir["#{libexec}/cyclone/*.sld"]
    (share/"cyclone/libs").install_symlink Dir["#{libexec}/cyclone/*.scm"]
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
