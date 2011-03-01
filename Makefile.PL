use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => 'Subscribe::List::SPPM',
    AUTHOR =>
      q{Daniel de Oliveira Mantovani <daniel.oliveira.mantovani@gmail.com>},
    VERSION_FROM  => 'lib/Subscribe/List/SPPM.pm',
    ABSTRACT_FROM => 'lib/Subscribe/List/SPPM.pm',
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002
        ? ( 'LICENSE' => 'perl' )
        : () ),
    PL_FILES  => {},
    PREREQ_PM => {
        'Test::More'      => 0,
        'WWW::Mechanize', => 0,
        Moose             => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Subscribe-List-SPPM-*' },
);
