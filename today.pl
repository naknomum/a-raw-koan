#!/usr/bin/perl

use Net::Twitter;
use Image::Magick;
use Data::Dumper;
require 'keys.pl';

my $file = '/tmp/today.png';
my @d = gmtime();
my $text = sprintf('%04d-%02d-%02d', $d[5]+1900, $d[4]+1, $d[3]);
my $image = Image::Magick->new;
$image->Set(size => '1024x768');
$image->ReadImage('xc:black');
$image->Annotate(pointsize => 150, fill => 'white', text => $text, gravity => 'center');
$image->Write("png:$file");

my $nt = Net::Twitter->new(
    traits   => [qw/API::RESTv1_1/],
    %keys
);

my $tmedia = $nt->upload([$file, "A raw koan: $text"]);
my $result = $nt->update({status => "A raw koan: $text", media_ids => $tmedia->{media_id}});
printf("https://twitter.com/statuses/%s\n", $result->{id});

