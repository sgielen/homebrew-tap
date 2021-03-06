require 'formula'

class Shogun < Formula
  homepage 'http://www.shogun-toolbox.org'
  url 'http://shogun-toolbox.org/archives/shogun/releases/3.1/sources/shogun-3.1.1.tar.bz2'
  sha1 'a403a6fc8681232ebd7c7c0e5cba65db39eb549f'

  option 'disable-svm-light', 'Disable SVM-light module, which is GPLv3 and makes all of shogun GPLv3'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'hdf5' => :recommended
  depends_on 'json-c' => :recommended
  depends_on 'readline' => :recommended
  depends_on 'nlopt' => :recommended
  depends_on 'eigen' => :recommended
  depends_on 'glpk' => :recommended
  depends_on 'lzo' => :recommended
  depends_on 'snappy' => :recommended
  depends_on 'xz' => :recommended  # provides lzma
  depends_on 'swig' => [:recommended, :build] # needef for dynamic python bindings
  depends_on 'numpy' => :python # You may want `brew tap homebrew/python && brew install numpy`
  depends_on 'matplotlib' => :python # You may want `brew tap homebrew/python && brew install matplotlib`
  depends_on 'r' => :optional
  depends_on 'lua' => :optional
  depends_on 'octave' => :optional

  # Todo: support additional deps: arpack, mosek, superlu, cplex, lpsolve
  #       Help us by hacking on this and open a pull request! Thanks.
  def install
    pydir = "#{which_python}/site-packages"

    args = [ "--prefix=#{prefix}",
             "--pydir=#{pydir}",
             "--enable-hmm-parallel" ]
    args << "--disable-svm-light" if build.include? 'disable-svm-light'

    # Todo: if we have depends_on :python => :recommended, we can disable
    #       swig, numpy and matplotlib deps if `--without-python`.

    unless MacOS::CLT.installed?
      # fix: "Checking for Mac OS vector library ... no"
      ["src/configure", "src/shogun/mathematics/lapack.h"].each do |f|
        inreplace f, "#include </System/Library/Frameworks/vecLib.framework",
                     "#include <#{MacOS.sdk_path}/System/Library/Frameworks/vecLib.framework"
      end
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make install"
    share.install Dir['examples']
  end

  test do
    (testpath/'test.sg').write <<-EOF.undent
      new_classifier LIBSVM
      save_classifier test.model
      exit
    EOF
    system bin/"shogun", "test.sg"
    raise "failed" unless File.exist?("test.model")

    # if build.with? 'python'
    #   system "python", share/"examples/documented/python_modular/graphical/svm.py"
    # end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
