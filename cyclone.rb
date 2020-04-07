class Cyclone < Formula
  desc ":cyclone: A brand-new compiler that allows practical application development using R7RS Scheme."
  homepage "http://justinethier.github.io/cyclone/"
  url "https://github.com/justinethier/cyclone/archive/v0.17.tar.gz"
  sha256 "5b623c90e53b44f27a13cda598747a6afc46591eb4bf5f11c17c39f422514fcc"
  version "v0.17"
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
  end

  def install_cyclone_files
    bin.mkdir
    include.mkdir
    libexec.install %w[scheme srfi include]
    mkdir libexec/"bin"
    (libexec/"bin").install "cyclone"
    (libexec/"bin").install "icyc"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mkdir libexec/"lib"
    (libexec/"lib").install "libcyclone.a"
    (libexec/"lib").install "libcyclonebn.a"
    lib.install_symlink Dir["#{libexec}/lib/*"]
    mkdir include/"cyclone"
    (include/"cyclone").install_symlink Dir["#{libexec}/include/cyclone/*.h"]
    mkdir share/"cyclone/cyclone"
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/cyclone/cyclone/*.sld"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/cyclone/cyclone/*.scm"]
    mkdir share/"cyclone/scheme"
    mkdir share/"cyclone/scheme/cyclone"
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.o"]
        (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.so"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.scm"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/test.meta"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/match.meta"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/array-list.meta"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.o"]
    (share/"cyclone/scheme/cyclone").install_symlink Dir["#{libexec}/scheme/cyclone/*.so"]
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
