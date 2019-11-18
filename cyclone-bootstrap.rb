class CycloneBootstrap < Formula
  desc ":cyclone-bootstrap: R7RS Scheme compiler used to bootstrap the cyclone R7RS Scheme compiler"
  homepage "http://justinethier.github.io/cyclone/"
  url "https://github.com/justinethier/cyclone-bootstrap/archive/v0.11.5.tar.gz"
  sha256 "7e231f3fecc828ca6c6dd1ef34495b96f235894fee2762b7f6581380cbe36ac9"
  version "v0.11.5"
  depends_on "git"
  depends_on "gcc"
  depends_on "libtommath"
  depends_on "ck"
  depends_on "cyclone-bootstrap"
  depends_on :xcode 

  def install_cyclone_lib_files
    lib.mkdir
    libexec.install %w[libs]
    share.mkdir
    mkdir share/"cyclone"
    mkdir share/"cyclone/cyclone"
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.sld"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.scm"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.c"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/test.meta"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/match.meta"]
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
    lib.install_symlink Dir["#{libexec}/lib/*"]
    mkdir include/"cyclone"
    (include/"cyclone").install_symlink Dir["#{libexec}/include/cyclone/*.h"]
    mkdir share/"cyclone/cyclone"
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.sld"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.scm"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/test.meta"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/match.meta"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.o"]
    (share/"cyclone/cyclone").install_symlink Dir["#{libexec}/libs/cyclone/*.so"]
    mkdir share/"cyclone/scheme"
    mkdir share/"cyclone/scheme/cyclone"
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.o"]
        (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/*.so"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.sld"]
    (share/"cyclone/scheme").install_symlink Dir["#{libexec}/scheme/cyclone/*.scm"]
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
    if self.class.name == "CycloneBootstrap"
    	system "gmake"
        install_cyclone_lib_files 
    else
        install_cyclone_lib_files 
    	system "gmake"
    end
    install_cyclone_files
  end

  test do
      system "gmake test"
  end
end
