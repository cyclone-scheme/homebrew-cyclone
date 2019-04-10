class Cyclone < Formula
  desc ":cyclone: A brand-new compiler that allows practical application development using R7RS Scheme."
  homepage "http://justinethier.github.io/cyclone/"
  url "https://github.com/justinethier/cyclone/archive/v0.10.tar.gz"
  sha256 "c96155cb08c9d97cb6d4e65055ebbf74e8f5e0b05eb336c727ca96705488aba8"
  depends_on "git"
  depends_on "gcc"
  depends_on "libtommath"
  depends_on "ck"
  depends_on :xcode 

  def install_cyclone_files
    bin.install "cyclone"
    bin.install "icyc"
    lib.install "libcyclone.a"
    (include/"cyclone").install Dir["include/cyclone/*.h"] 
    (share/"cyclone/scheme").install Dir["scheme/*.sld"]
    (share/"cyclone/scheme").install Dir["scheme/*.o"]
	(share/"cyclone/scheme").install Dir["scheme/*.so"]
    (share/"cyclone/scheme").install Dir["scheme/cyclone/*.sld"]
    (share/"cyclone/scheme").install Dir["scheme/cyclone/*.scm"]
    (share/"cyclone/scheme").install Dir["scheme/cyclone/test.meta"]
    (share/"cyclone/scheme").install Dir["scheme/cyclone/match.meta"]
    (share/"cyclone/scheme").install Dir["scheme/cyclone/array-list.meta"]
    (share/"cyclone/scheme/cyclone").install Dir["scheme/cyclone/*.o"]
    (share/"cyclone/scheme/cyclone").install Dir["scheme/cyclone/*.so"]
    (share/"cyclone/srfi").install Dir["srfi/*.sld"]
    (share/"cyclone/srfi").install Dir["srfi/*.scm"]
    (share/"cyclone/srfi/list-queues").install Dir["srfi/list-queues/*.scm"]
    (share/"cyclone/srfi/sorting").install Dir["srfi/sorting/*.scm"]
    (share/"cyclone/srfi/sets").install Dir["srfi/sets/*.scm"]
    (share/"cyclone/srfi").install Dir["srfi/*.meta"]
    (share/"cyclone/srfi").install Dir["srfi/*.o"]
    (share/"cyclone/srfi").install Dir["srfi/*.so"]
  end     

  def install
    builddir = Dir.pwd
    system "git clone https://github.com/adamfeuer/cyclone-bootstrap.git"
    Dir.chdir('cyclone-bootstrap')
    #system "git checkout homebrew-experiments" 
    system "make"
    install_cyclone_files

    Dir.chdir(builddir)
    #system "make"
    #install_cyclone_files
  end

  test do
      system "make test"
  end
end
