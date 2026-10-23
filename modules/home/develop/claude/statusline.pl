#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use JSON::PP;

binmode(STDOUT, ':encoding(UTF-8)');
open(STDERR, '>', '/dev/null');

my $RESET = "\e[0m";
my $BOLD  = "\e[1m";
my $DIM   = "\e[2m";
my %FG = (
    red     => "\e[31m", green   => "\e[32m", yellow  => "\e[33m",
    blue    => "\e[34m", magenta => "\e[35m", cyan    => "\e[36m",
);

my $GIT = $ARGV[0] // 'git';
my $j = decode_json(do { local $/; <STDIN> });

sub paint {
    my ($color, $text) = @_;
    return "$color$text$RESET";
}

sub model_name {
    my ($model) = @_;
    my $id = $model->{id} // '';
    return ucfirst($1) . (defined $3 ? " $2.$3" : " $2")
        if $id =~ /^claude-([a-z]+)-(\d+)(?:-(\d{1,2}))?(?!\d)/;
    return ucfirst($3) . (defined $2 ? " $1.$2" : " $1")
        if $id =~ /^claude-(\d+)(?:-(\d))?-([a-z]+)/;
    return $model->{display_name} // 'Claude';
}

sub git_state {
    my ($dir) = @_;
    return '' unless length $dir;
    open(my $fh, '-|', $GIT, '-C', $dir, '--no-optional-locks',
        'status', '--porcelain=v2', '--branch') or return '';
    my ($head, $oid, $dirty) = ('', '', 0);
    while (my $line = <$fh>) {
        if    ($line =~ /^# branch\.head (.+)$/)  { $head = $1 }
        elsif ($line =~ /^# branch\.oid (\w{7})/) { $oid = $1 }
        elsif ($line !~ /^#/)                     { $dirty = 1 }
    }
    close($fh) or return '';
    $head = $oid if $head eq '(detached)';
    return paint($FG{blue}, $head) . ($dirty ? paint($FG{yellow}, '●') : '');
}

sub pull_request {
    my ($pr) = @_;
    return '' unless $pr && $pr->{number};
    my $state = $pr->{review_state} // '';
    my %color = (approved => $FG{green}, changes_requested => $FG{red});
    return paint($color{$state} // $DIM, join(' ', "#$pr->{number}", $state || ()));
}

sub tokens {
    my ($n) = @_;
    return sprintf('%.1fM', $n / 1e6) =~ s/\.0M$/M/r if $n >= 1e6;
    return sprintf('%dk', $n / 1e3) if $n >= 1e3;
    return int($n);
}

sub duration {
    my ($s) = @_;
    my ($d, $h, $m) = (int($s / 86400), int($s % 86400 / 3600), int($s % 3600 / 60));
    return $d ? "${d}d" . ($h ? "${h}h" : '') : $h ? "${h}h${m}m" : "${m}m";
}

sub limit {
    my ($label, $limit, $window) = @_;
    return () unless $limit && defined $limit->{used_percentage};
    my $used  = $limit->{used_percentage};
    my $left  = ($limit->{resets_at} // 0) - time;
    my $text  = sprintf('%s %d%%', $label, $used);
    my $color = $used >= 90 ? $FG{red} : $FG{green};
    if ($left > 0) {
        my $over = $used > 100 * (1 - $left / $window);
        $text .= ($over ? '↑' : '↓') . ' ' . duration($left);
        $color = $FG{yellow} if $over && $used < 90;
    }
    return paint($color, $text);
}

my $cwd     = $j->{workspace}{current_dir} // '';
my $dir     = $cwd =~ s|^\Q$ENV{HOME}\E|~|r;
my $pct     = $j->{context_window}{used_percentage}     // 0;
my $size    = $j->{context_window}{context_window_size} // 0;
my $cost    = $j->{cost}{total_cost_usd}                // 0;
my $added   = $j->{cost}{total_lines_added}             // 0;
my $removed = $j->{cost}{total_lines_removed}           // 0;
my $rl      = $j->{rate_limits};

my $where = join(' ',
    paint("$BOLD$FG{cyan}", '[' . model_name($j->{model}) . ']'),
    length $dir ? paint($FG{yellow}, $dir) : (),
    git_state($cwd) || (),
    pull_request($j->{pr}) || ());

my $mode = join(' ', grep { defined } $j->{effort}{level}, $j->{fast_mode} ? 'fast' : undef);

my $ctx_color = $pct < 50 ? $FG{green} : $pct < 80 ? $FG{yellow} : $FG{red};
my $ctx = sprintf('ctx %d%%', $pct);
$ctx .= ' ' . tokens($pct * $size / 100) . '/' . tokens($size) if $size;

my @usage = $rl
    ? (limit('5h', $rl->{five_hour}, 5 * 3600), limit('7d', $rl->{seven_day}, 7 * 86400))
    : ();

my $cost_color = $cost < 1 ? $FG{green} : $cost < 5 ? $FG{yellow} : $FG{red};

print join(" $DIM│$RESET ",
    $where,
    length $mode ? paint($FG{magenta}, $mode) : (),
    paint($ctx_color, $ctx),
    @usage ? join('  ', @usage) : paint($cost_color, sprintf('$%.2f', $cost)),
    paint($FG{green}, "+$added") . ' ' . paint($FG{red}, "-$removed"));
