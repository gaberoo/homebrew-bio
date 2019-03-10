class TaxatorTk < Formula
  # cite Dr_ge_2014: "https://doi.org/10.1093/bioinformatics/btu745"
  desc "Programs for the taxonomic analysis of nucleotide sequence data"
  homepage "https://research.bifo.helmholtz-hzi.de"
  url "https://github.com/fungs/taxator-tk/archive/v1.3.3.tar.gz"
  sha256 "c1da90bee42337a994c66653208c820b7b0d203093981eaec4eef0a9f6fdd156"

  depends_on "cmake" => :build
  depends_on "boost"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install "build/binner", "build/taxator", "build/unittest_ncbitaxonomy", "build/alignments-filter", "build/taxknife"
  end

  test do
    assert_match "Allowed options", shell_output("#{bin}/taxator --help")
  end
end

__END__
diff --git a/taxator.cpp b/taxator.cpp
index 9c734d2..16a3d84 100644
--- a/taxator.cpp
+++ b/taxator.cpp
@@ -304,12 +304,22 @@ int main( int argc, char** argv ) {
     try {
       // choose appropriate prediction model from command line parameters
       //TODO: "address of temporary warning" is annoying but life-time is guaranteed until function returns
-      if( algorithm == "dummy" ) doPredictions( &DummyPredictionModel< RecordSetType >( tax.get() ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
-      else if( algorithm == "simple-lca" ) doPredictions( &LCASimplePredictionModel< RecordSetType >( tax.get() ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
-      else if( algorithm == "megan-lca" ) doPredictions( &MeganLCAPredictionModel< RecordSetType >( tax.get(), ignore_unclassified, toppercent, minscore, minsupport, maxevalue ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
-      else if( algorithm == "ic-megan-lca" ) doPredictions( &MeganLCAPredictionModel< RecordSetType >( tax.get(), ignore_unclassified, toppercent, minscore, minsupport, maxevalue ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
-      else if( algorithm == "n-best-lca" ) doPredictions( &NBestLCAPredictionModel< RecordSetType >( tax.get(), nbest ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
-      else if( algorithm == "rpa" ) {
+      if( algorithm == "dummy" ) {
+        auto dpm = DummyPredictionModel< RecordSetType >( tax.get() );
+        doPredictions( &dpm, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
+      } else if( algorithm == "simple-lca" ) {
+        auto lcas = LCASimplePredictionModel< RecordSetType >( tax.get() );
+        doPredictions( &lcas, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
+      } else if( algorithm == "megan-lca" ) {
+        auto megan = MeganLCAPredictionModel< RecordSetType >( tax.get(), ignore_unclassified, toppercent, minscore, minsupport, maxevalue );
+        doPredictions( &megan, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
+      } else if( algorithm == "ic-megan-lca" ) {
+        auto megan = MeganLCAPredictionModel< RecordSetType >( tax.get(), ignore_unclassified, toppercent, minscore, minsupport, maxevalue );
+        doPredictions( &megan, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
+      } else if( algorithm == "n-best-lca" ) {
+        auto nbestLCA = NBestLCAPredictionModel< RecordSetType >( tax.get(), nbest );
+        doPredictions( &nbestLCA, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );
+      } else if( algorithm == "rpa" ) {
           typedef seqan::String< seqan::Dna5 > StringType;
           // load query sequences
           boost::scoped_ptr< RandomSeqStoreROInterface< StringType > > query_storage;
@@ -324,7 +334,8 @@ int main( int argc, char** argv ) {
           else db_storage.reset( new RandomIndexedSeqstoreRO< StringType >( db_filename, db_index_filename ) );
           measure_db_loading.stop();
 
-          doPredictions( &RPAPredictionModel< RecordSetType, RandomSeqStoreROInterface< StringType >, RandomSeqStoreROInterface< StringType > >( tax.get(), *query_storage, *db_storage, filterout, toppercent ), *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );  // TODO: reuse toppercent param?
+          auto rpapred = RPAPredictionModel< RecordSetType, RandomSeqStoreROInterface< StringType >, RandomSeqStoreROInterface< StringType > >( tax.get(), *query_storage, *db_storage, filterout, toppercent );
+          doPredictions( &rpapred, *seqid2taxid, tax.get(), split_alignments, alignments_sorted, logsink, number_threads );  // TODO: reuse toppercent param?
       } else {
           cout << "classification algorithm can either be: rpa (default), simple-lca, megan-lca, ic-megan-lca, n-best-lca" << endl;
           return EXIT_FAILURE;
