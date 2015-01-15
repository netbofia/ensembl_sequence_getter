#!/usr/local/bin/perl

use warnings;
use Bio::EnsEMBL::Registry;
use File::Basename;
use File::Path qw/make_path/;


Bio::EnsEMBL::Registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous',
    -port => 5306);

  my @gene_list=qw(Adam10 Adam17 Aire ccl25 ccr9 cd3 cd4 cd8 Chuk Ctnnb1 cxcl12 CXCR4 CXCR7 Dll1 dll4 Dtx1 Foxn1 foxp3 Gcm2 hes1 hoxa3 HOXB4 IFNG Il17b Il2ra il6st Jag1 Jag2 Lmo2 Nfkb1 Notch2 Notch4 Psen1 Psen2 Ptcra Runx1 Shh Stat6 v-erb-b2);

  my $registry= Bio::EnsEMBL::Registry;
  print "stable_id_list = qw(";
  my $gene_adaptor = $registry->get_adaptor('Human', 'Core', 'Gene');
  foreach $external_name (@gene_list){
    @genes = @{ $gene_adaptor->fetch_all_by_external_name($external_name)};
    foreach $gene (@genes) {
      print $gene->external_name," --> ",$gene->stable_id , "\n";
      #print $gene->stable_id," "
    }
  }
  print ");";
