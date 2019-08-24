# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Roary < Formula
  desc "Rapid large-scale prokaryote pan genome analysis"
  homepage "http://sanger-pathogens.github.io/Roary"
  url "https://github.com/sanger-pathogens/Roary/archive/v3.12.0.tar.gz"
  sha256 "84cfb86845e8f6c4b13d52b6e8634b9a1289c662d8c6f33310bb4d54ade941bc"
  # cite Page_2015: "https://doi.org/10.1093/bioinformatics/btv421"

  depends_on "cpanminus" => :build
  depends_on "bioperl"
  depends_on "blast"
  depends_on "cd-hit"
  depends_on "fasttree"
  depends_on "mafft"
  depends_on "mcl"
  depends_on "parallel"
  depends_on "prank"

  unless OS.mac?
    depends_on "perl"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["bioperl"].libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", prefix/"perl5/lib/perl5"
    system "cpanm", "--self-contained", "-l", prefix/"perl5", "Bio::Roary"
    doc.install %w[AUTHORS GPL-LICENSE README.md]
  end

  test do
    assert_match "core", shell_output("#{bin}/roary -h 2>&1", 0)
  end
end
