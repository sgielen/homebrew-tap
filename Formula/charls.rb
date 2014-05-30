require "formula"

class Charls < Formula
  homepage "http://charls.codeplex.com/"
  url "http://ftp.de.debian.org/debian/pool/main/c/charls/charls_1.0.orig.tar.gz"
  sha1 "7f9165bdfde7809c1d4e268e8d01c0938021bb67"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make CharLS"
    system "mkdir -p /usr/local/Cellar/charls/1.0/lib"
    system "mkdir -p /usr/local/Cellar/charls/1.0/include"
    system "cp libCharLS.a /usr/local/Cellar/charls/1.0/lib"
    system "cp *.h /usr/local/Cellar/charls/1.0/include"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test charls`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
