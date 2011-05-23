package PrivateLabelFeed::Plugin;

use strict;
use warnings;

use File::Copy;

sub callback_build_file {
    my ($cb, %args) = @_;
    my $file = $args{file};
    my $file_info = $args{file_info};
    my $template = $args{template};
    use Data::Dumper;
    MT->log("file_info: " . Dumper($file_info));
    MT->log("template identifier: ".$template->identifier);
    MT->log("build_file got file: $file");

    if ($template->identifier eq 'feed_recent') {
        my $blog = $args{blog};
        my $blog_id = $blog->id;
        my $scope = "blog:" . $blog->id;
        MT->log($blog->name . "/" . $blog->id);

        my $plugin = MT->component('PrivateLabelFeed');
        my $feed_url = $plugin->get_config_value('feedburner_feed_url', $scope);

        MT->log("feed_url: $feed_url");

        if ($feed_url) {
            # feed url is set, so we need to move the file
            my @file_bits = split /\//, $file;
            my $file_name = pop @file_bits;
            MT->log($file_name);
            
            my @file_name_bits = split /\./, $file_name;
            my $file_short_name = $file_name_bits[0];
            MT->log($file_short_name);
            
            my $ext = $file_name_bits[1];
            MT->log($ext);
            
            my $file_dir = join '/', @file_bits;
            MT->log($file_dir);

            my $new_file_name = "$file_short_name-private.$ext";
            my $new_file_path = join '/', ($file_dir, $new_file_name);
            MT->log("new file path: $new_file_path");
            
            File::Copy::copy($file, $new_file_path);
            
            # my 
        }        
    }
}

1;