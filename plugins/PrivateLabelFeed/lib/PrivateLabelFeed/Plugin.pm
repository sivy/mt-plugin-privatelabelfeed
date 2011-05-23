package PrivateLabelFeed::Plugin;

use strict;
use warnings;

use File::Copy;

sub callback_build_file {
    my ($cb, %args) = @_;
    my $file = $args{file};
    my $file_info = $args{file_info};
    my $template = $args{template};
    
    if ($template->identifier eq 'feed_recent') {
        my $blog = $args{blog};
        my $blog_id = $blog->id;
        my $scope = "blog:" . $blog->id;

        my $plugin = MT->component('PrivateLabelFeed');
        my $feed_url = $plugin->get_config_value('feedburner_feed_url', $scope);

        if ($feed_url) {
            # feed url is set, so we need to move the file
            my @file_bits = split /\//, $file;
            my $file_name = pop @file_bits;
            
            my @file_name_bits = split /\./, $file_name;
            my $file_short_name = $file_name_bits[0];
            
            my $ext = $file_name_bits[1];
            
            my $file_dir = join '/', @file_bits;

            my $new_file_name = "$file_short_name-private.$ext";
            my $new_file_path = join '/', ($file_dir, $new_file_name);
            
            File::Copy::copy($file, $new_file_path);
        }        
    }
}

1;