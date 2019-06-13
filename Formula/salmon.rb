class Salmon < Formula
  # cite Patro_2017: "https://doi.org/10.1038/nmeth.4197"
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/v0.14.0.tar.gz"
  sha256 "4a9db47d2270aaba227602fae2ce414122db783200023cf46efe7644846b0d83"
  head "https://github.com/COMBINE-lab/salmon.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any
    sha256 "48292242cc8968b741494a8b0c2115e963f8d556f69e91a93b0b06f7e01c6c19" => :sierra
    sha256 "402f7b66bcbf4347dbfedd8e39507024ad223b31b915a42f28cec37e2254a372" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "cereal" => :build
  depends_on "jemalloc"
  depends_on "libdivsufsort"
  depends_on "staden-io-lib"
  depends_on "tbb"
  depends_on "xz"

  unless OS.mac?
    depends_on "unzip" => :build
    depends_on "zlib"
  end

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j1" if ENV["CIRCLECI"]

    if OS.mac?
      inreplace "include/spdlog/fmt/bundled/format.h", 
                "FMT_HAS_INCLUDE(<string_view>) && __cplusplus > 201402L", 
                "FMT_HAS_INCLUDE(<string_view>)"
      inreplace "include/stx/string_view.hpp",
                "__has_include(<string_view>) && (__cplusplus > 201402)",
                "__has_include(<string_view>)"
    end

    system "cmake", ".", "-DUSE_SHARED_LIBS=1", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/salmon --help 2>&1")
  end
end
