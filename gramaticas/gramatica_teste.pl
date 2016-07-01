#!/usr/bin/perl

use strict;
use warnings;
use Marpa::R2;
use Data::Dumper;
use XML::Simple;
use POSIX qw( strftime );

my $grammar = Marpa::R2::Scanless::G->new({
        default_action => '::array',
        source         => \(<<'END_OF_SOURCE'),
:start          ::= Projeto
Projeto         ::= label_nome nome label_metas Metas label_perguntas Perguntas label_urls Urls   action => pairs
nome            ::= <string>          action => remove_quotes

Metas           ::= Info+             action => metas
Info            ::= '#' <string>      action => snd

Perguntas       ::= Pergunta+                   action => perguntas
Pergunta        ::= '#' <string>                action => snd
                ||  '#' Condition               action => snd

Urls            ::= Url+              action => urls
Url             ::= '#' <string>      action => snd

label_nome      ::= 'name' ':'        action => fst
label_metas     ::= 'meta' ':'       action => fst
label_perguntas ::= 'perguntas' ':'   action => fst
label_urls      ::= 'urls' ':'        action => fst

<string>        ~ '"'<alot>'"'
<alot>          ~ [^"]+

Condition       ::= '(' Metafield Op Value ')' <string>  action => question_attrs
Metafield       ::= <string>          action => remove_quotes
Op              ::= '=='              action => op_code
                |   '!='              action => op_code
                |   '<'               action => op_code
                |   '>'               action => op_code
                |   '<='              action => op_code
                |   '>='              action => op_code
                |   'regex'           action => op_code
Value           ::= <string>          action => remove_quotes
                | <num>
<num>           ~ [0-9]+

:discard        ~ ws
ws              ~ [\s\n\t]+

END_OF_SOURCE
});

my $re = Marpa::R2::Scanless::R->new({ grammar => $grammar, semantics_package =>'main' });
my $input = "name: \"Gammers\" metas:     # \"idade\"     # \"nome\"     # \"morada\"     # \"telefone\" perguntas:     #(\"lisboa\" regex \"morada\")\"O primeiro grande jogo da programacao\"     # \"genero preferido\"     # \"jogo favorito\"     # \"comunidade a que pertence\"     # ( \"20\" < \"idade\" ) \"amigos\"      urls:     # \"www.mp.pt\"";
*STDERR = *STDOUT;
$input = join(' ', @ARGV);
$input =~ s/\\n/\n/g;
#print "Trying to parse:\n$input\n\n";

$re->read(\$input);
my $value = ${$re->value};

#--- Data::Dumper Print-Out ---#
#print "Output:\n".Dumper($value);

$value->{'editable'} = 'yes';
$value->{'time'} = strftime("%d-%m-%y %H:%M:%S", localtime);

#--- XML::Simple Print-Out ---#
print XMLout($value, RootName => "project", XMLDecl => 1, ContentKey => 'content');

#--- DSL semantics ---#
#sub set_question_attrs { {{$_[2]}{'content'} => $_[3]}  }
sub question_attrs { $_[6] =~ s/["]//g; {'value'=>$_[2], 'op'=>$_[3], 'metafield'=>$_[4], 'content'=>$_[6]} }
sub pairs  { shift; +{ map @$_, \@_ } }
sub metas  { shift; {'info'=>\@_}}
sub perguntas  { shift; {'p'=>\@_}}
sub urls  { shift; {'url'=>\@_}}
sub fst   { $_[1] }
sub snd   { $_[2] =~ s/["]//g; $_[2]}
sub remove_quotes   { $_[1] =~ s/["]//g; $_[1]}
sub op_code {
      if($_[1] eq '=='   )  {return 1;}
      if($_[1] eq '!='   )  {return 2;}
      if($_[1] eq '<'    )  {return 3;}
      if($_[1] eq '>'    )  {return 4;}
      if($_[1] eq '<='   )  {return 5;}
      if($_[1] eq '>='   )  {return 6;}
      if($_[1] eq 'regex')  {return 7;}
}
