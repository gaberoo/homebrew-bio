class Libgff < Formula
  desc "GFF/GTF parsing code that is used in the Cufflinks codebase"
  homepage "https://github.com/COMBINE-lab/libgff"
  url "https://github.com/COMBINE-lab/libgff/archive/v1.2.tar.gz"
  sha256 "bfabf143da828e8db251104341b934458c19d3e3c592d418d228de42becf98eb"
  head "https://github.com/COMBINE-lab/libgff.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
