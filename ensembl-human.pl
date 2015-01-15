#!/usr/bin/perl

use warnings;
use Bio::EnsEMBL::Registry;
use File::Basename;
use File::Path qw/make_path/;


Bio::EnsEMBL::Registry->load_registry_from_db(
    -host => 'ensembldb.ensembl.org',
    -user => 'anonymous',
    -port => 5306);

  #List of stable_id genes for the sequence of genes.
  my @stable_id_list = qw(ENSG00000137845 ENSG00000151694 ENSG00000160224 ENSG00000131142 ENSG00000173585 ENSG00000144648 ENSG00000010610 ENSG00000153563 ENSG00000213341 ENSG00000168036 ENSG00000107562 ENSG00000121966 ENSG00000144476 ENSG00000198719 ENSG00000128917 ENSG00000135144 ENSG00000109101 ENSG00000049768 ENSG00000124827 ENSG00000276612 ENSG00000160221 ENSG00000114315 ENSG00000105997 ENSG00000182742 ENSG00000111537 ENSG00000127743 ENSG00000134460 ENSG00000134352 ENSG00000101384 ENSG00000184916 ENSG00000135363 ENSG00000109320 ENSG00000134250 ENSG00000204301 ENSG00000080815 ENSG00000143801 ENSG00000171611 ENSG00000159216 ENSG00000079102 ENSG00000164690 ENSG00000166888 );

  my $registry= Bio::EnsEMBL::Registry;

  my $gene_member_adaptor = $registry->get_adaptor('Multi', 'compara', 'GeneMember');
  
  foreach $stable_id_human (@stable_id_list){
   
  
   #get the gene member to find homologies
   my $gene_member = $gene_member_adaptor->fetch_by_stable_id($stable_id_human);
  
   my $homology_adaptor = $registry->get_adaptor('Multi', 'compara', 'Homology');
   my $homologies = $homology_adaptor->fetch_all_by_Member($gene_member);
  
  # foreach $homology (@{$homologies}){
     my $homology= $homologies->[0];
     
     my $gene_list_1 = $homology->gene_list->[0];
     my $taxon = $gene_list_1->taxon;
     print "---------------------------------------------------------\n";
     print "| Stable_id: ", $gene_list_1->stable_id,"\n";
     print "| Description: ", $gene_list_1->description, "\n";
     print "| Genome_db: ", $gene_list_1->genome_db->name ," Genome_db_name: ", $gene_list_1->genome_db_id, "\n";
     print "| Common_name: ", $taxon->common_name,"\n";
     print "| genus: ", $taxon->genus,"\n";
     print "| species: ", $taxon->species,"\n";
     print "| binomial: ", $taxon->binomial,"\n";
     print "| classification: ", $taxon->classification,"\n";
     print "| Homology->description: ",$homology->description," Homology->taxonomy_level: ", $homology->taxonomy_level,"\n";
     
     print "---------------------------------------------------------\n";
     
  
     my $db_name= $gene_list_1->genome_db->name;
     my $gene_adaptor=$registry->get_adaptor($db_name,'Core','Gene');
     my $sp_gene_stable_id=$gene_list_1->stable_id;
     my $sp_gene=$gene_adaptor->fetch_by_stable_id($sp_gene_stable_id);   
  
     #Get all transcripts for specified gene from database    
     my $all_transcripts=$sp_gene->get_all_Transcripts;
     foreach my $transcripts ($all_transcripts){
       foreach $transcript (@{$transcripts}){ 
         print $transcript->stable_id, " ";
         print $transcript->translateable_seq,"\n";
         my @classification = split(' ',$taxon->classification);

         #save to file 
         my $file_name="seq3\/".$stable_id_human."\/".$homology->description."\/".@classification->[3]."\/".$taxon->binomial.$sp_gene->external_name.".txt";
         my $dir = dirname($file_name);
         make_path($dir);
         print $file_name;
         open (MYFILE, '>>',$file_name);
         print MYFILE ">",$transcript->stable_id," cds:".$gene_list_1->description."\n",$transcript->translateable_seq,"\n";
         close(MYFILE);
        }
      }
   # }
  }
