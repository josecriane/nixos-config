#!/usr/bin/env perl

# PreToolUse gate for Write, Edit, NotebookEdit and Bash.
#
# Inspects only the text being introduced (not the whole file) and exits 2
# with a message on stderr when it finds a hard style violation. Exit 2
# blocks the tool call and feeds stderr back to Claude. For Bash it looks
# only at `git commit` invocations. Markdown prose and commit messages
# also get the ASD-STE100 lexical checks from rules/simple-english.md.
#
# Fails open on any internal error: a broken gate must not wedge a session.
# Set CLAUDE_STYLE_GATE=off to disable.

use strict;
use warnings;
use JSON::PP;

binmode(STDERR, ':encoding(UTF-8)');

sub bail_open { exit 0 }

exit 0 if ($ENV{CLAUDE_STYLE_GATE} // 'on') =~ /^(off|0|no|false)$/i;

my @SKIP = (
    qr{(^|/)\.git(/|$)},
    qr{(^|/)(deps|_build|node_modules|fixtures|vendor|cover|doc|result)(/|$)},
    qr{(^|/)(\.elixir_ls|\.lexical|_opam|\.formatted)(/|$)},
    # The rule files and this gate necessarily quote the words they ban.
    qr{(^|/)\.claude(/|$)},
    qr{(^|/)claude(/|$)},
    qr{(^|/)claude_improvs(/|$)},
    qr{CHANGELOG},
    qr{(^|/)(mix|flake|rebar)\.lock$},
    qr{(^|/)package-lock\.json$},
);

my %SOURCE_EXT = map { $_ => 1 }
    qw(.ex .exs .erl .hrl .ml .mli .nix .sh .bash .ts .tsx .js .py .rs .go .c .h);

my %OCAML_EXT = map { $_ => 1 } qw(.ml .mli);

my %DASH = (
    "\x{2014}" => 'em dash (U+2014)',
    "\x{2015}" => 'horizontal bar (U+2015)',
);

my $EMOJI = qr{[\x{1F000}-\x{1FAFF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}\x{2B00}-\x{2BFF}\x{FE0F}]};

my $BANNED_WORDS = qr{\b(delve[sd]?|delving|tapestr(?:y|ies)|multifaceted
    |testament|cutting[-\s]edge|revolutionar(?:y|ily)|game[-\s]changer
    |seamless(?:ly)?)\b}xi;

my $BANNED_PHRASES = qr{(it'?s\ important\ to\ note|in\ today'?s|let'?s\ dive\ in
    |in\ (?:summary|conclusion|essence)|first\ and\ foremost
    |is\ a\ testament\ to|ever[-\s]evolving
    |it'?s\ not\ just\ .{1,40}?,\ it'?s\ )}xi;

# `\(\*` consumes the second character of `(**`, so an odoc doc comment can
# never reach the code patterns that follow.
my $COMMENT_OPEN   = qr{(?:\#|%%|//|\(\*)};

my $DIVIDER        = qr{^\s*$COMMENT_OPEN\s*[-=*_]{3,}};
my $COMMENTED_CODE = qr{^\s*$COMMENT_OPEN\s*(?:defp?\s|defmacro\s|IO\.inspect|dbg\(|\|>
    |end\s*$|case\s.*\sdo\s*$
    |let\s+rec\s|let\s*\(\)\s*=|let[*+]?\s+\w[\w']*\s*=
    |val\s+\w[\w']*\s*:|module\s+[A-Z]\w*\s*=|match\s.*\swith\b)}x;
my $BARE_TODO      = qr{\b(?:TODO|FIXME|XXX)\b(?![^\n]*(?:\#\d+|GH-\d+|[A-Z]{2,}-\d+))};
my $DEBUG_LEFTOVER = qr{(?<![\w.])(IO\.inspect|dbg\(|:erlang\.display
    |print_endline|print_string|print_int|Printf\.printf|Format\.printf)}x;

my $OCAML_UNSAFE = qr{(?<![\w.])(Obj\.magic)\b};

my $TRAILER = qr{(Co-Authored-By\s*:|Generated\s+with\s+\[?Claude)}i;

my $STE_CONTRACTION = qr{\b(?:
      (?:do|does|did|is|are|was|were|ca|wo|has|have|had|must|need|ai|could|should|would)n't
    | (?:it|that|there|here|what|let)'s
    | (?:you|we|they)'(?:re|ve|ll|d)
    | i'(?:m|ve|ll|d)
)\b}xi;

my $STE_MODAL   = qr{\b(?:should|would|may|might|could)\b}i;
my $STE_PERFECT = qr{\b(?:has|have|had)\s+(?:been|\w+ed)\b}i;
my $STE_GERUND  = qr{,\s+(?:making|allowing|enabling|ensuring|providing|causing
    |resulting|creating|leading|meaning|reducing|improving|helping|giving)\b}xi;

my @COMMIT_TYPES = qw(feat fix chore docs refactor test perf build ci style revert);
my $CONVENTIONAL = do {
    my $types = join '|', @COMMIT_TYPES;
    qr{^(?:$types)(?:\([^)]+\))?!?:\s+\S}
};

my $raw = do { local $/; <STDIN> };
bail_open() unless defined $raw && length $raw;

my $event = eval { decode_json($raw) };
bail_open() unless ref $event eq 'HASH';

my $tool  = $event->{tool_name} // '';
my $input = $event->{tool_input};
bail_open() unless ref $input eq 'HASH';

my @findings;

if ($tool eq 'Bash') {
    push @findings, check_bash($input->{command});
}
else {
    my $path = $input->{file_path} // $input->{notebook_path} // '';
    my $base = ($path =~ m{([^/]+)$}) ? $1 : '';

    # COMMIT_EDITMSG lives under .git, which the skip list otherwise excludes.
    if ($base eq 'COMMIT_EDITMSG' || $base =~ /\.gitmessage$/) {
        push @findings, check_commit_message($_) for introduced($input);
    }
    else {
        bail_open() if skipped($path);
        push @findings, check_text($_, $path) for introduced($input);
    }
}

exit 0 unless @findings;

my (%seen, @lines);
for my $f (@findings) {
    next if $seen{$f}++;
    push @lines, "  $f";
    last if @lines >= 20;
}

print STDERR "Blocked by style gate. Fix these and retry:\n"
    . join("\n", @lines)
    . "\n\nSee ~/.claude/rules/writing-style.md, simple-english.md, code-comments.md, commits.md.\n";
exit 2;

sub skipped {
    my ($path) = @_;
    return 0 unless defined $path && length $path;
    for my $re (@SKIP) {
        return 1 if $path =~ $re;
    }
    return 0;
}

sub introduced {
    my ($input) = @_;
    my @chunks;
    for my $key (qw(content new_string new_source)) {
        my $v = $input->{$key};
        push @chunks, $v if defined $v && !ref $v;
    }
    if (ref $input->{edits} eq 'ARRAY') {
        for my $edit (@{ $input->{edits} }) {
            next unless ref $edit eq 'HASH';
            my $v = $edit->{new_string};
            push @chunks, $v if defined $v && !ref $v;
        }
    }
    return @chunks;
}

sub check_text {
    my ($text, $path) = @_;
    my $ext = ($path =~ m{(\.[^./]+)$}) ? lc($1) : '';
    my $is_source = $SOURCE_EXT{$ext} ? 1 : 0;
    my $is_lib    = $is_source && $path =~ m{(^|/)lib/} ? 1 : 0;
    my $is_ocaml  = $OCAML_EXT{$ext} ? 1 : 0;
    # Instruction files (CLAUDE.md, AGENTS.md) quote the words STE bans.
    my $is_doc = ($ext eq '.md' || $ext eq '.markdown')
        && $path !~ m{(^|/)(CLAUDE|AGENTS)[^/]*\.md$}i ? 1 : 0;

    my @out;
    my $n = 0;
    my $in_fence = 0;
    for my $line (split /\n/, $text, -1) {
        $n++;
        for my $char (keys %DASH) {
            push @out, "line $n: $DASH{$char}; use a comma, period, or parentheses"
                if index($line, $char) >= 0;
        }
        push @out, "line $n: emoji or status glyph '$1'" while $line =~ /($EMOJI)/g;
        push @out, "line $n: banned word '$1'"           while $line =~ /$BANNED_WORDS/g;
        push @out, "line $n: banned phrase '$1'"         while $line =~ /$BANNED_PHRASES/g;

        if ($is_doc) {
            if ($line =~ /^\s*(?:```|~~~)/) {
                $in_fence = !$in_fence;
            }
            elsif (!$in_fence && $line !~ /^(?: {4}|\t)/) {
                (my $prose = $line) =~ s/`[^`]*`//g;
                $prose =~ s/\]\([^)]*\)/]/g;
                push @out, "line $n: $_" for ste_scan($prose);
            }
        }

        next unless $is_source;
        push @out, "line $n: section divider comment"                      if $line =~ $DIVIDER;
        push @out, "line $n: commented-out code; delete it, git remembers" if $line =~ $COMMENTED_CODE;
        push @out, "line $n: TODO/FIXME without an issue reference"        if $line =~ $BARE_TODO;
        push @out, "line $n: debug call left in lib/"                      if $is_lib && $line =~ $DEBUG_LEFTOVER;
        push @out, "line $n: $1; there is a typed way to do this"          if $is_ocaml && $line =~ $OCAML_UNSAFE;
    }
    return @out;
}

sub ste_scan {
    my ($prose) = @_;
    my @out;
    push @out, "contraction '$1' (STE)" while $prose =~ /($STE_CONTRACTION)/g;
    push @out, "hedging modal '$1'; use must, can, will, or delete (STE)"
        while $prose =~ /($STE_MODAL)/g;
    push @out, "perfect tense '$1'; use the simple past (STE)"
        if $prose =~ /($STE_PERFECT)/;
    push @out, "participial clause '$1'; start a new sentence (STE)"
        if $prose =~ /($STE_GERUND)/;
    push @out, "semicolon; write two sentences (STE)"
        if $prose =~ /;/;
    return @out;
}

sub check_commit_message {
    my ($text) = @_;
    my @out;
    push @out, "commit message: $1 trailer is banned; leave the trailer block alone"
        if $text =~ $TRAILER;
    push @out, "commit message: emoji '$1'" if $text =~ /($EMOJI)/;

    (my $body = $text) =~ s/^# -+ >8 -+.*\z//ms;
    $body =~ s/^\s*#.*$//mg;
    $body =~ s/`[^`]*`//g;
    push @out, "commit message: $_" for ste_scan($body);

    my ($subject) = split /\n/, $text, 2;
    if (defined $subject && length $subject && $subject !~ /^\s*#/) {
        push @out, "commit subject: needs a conventional-commit prefix, e.g. 'fix: $subject'"
            unless $subject =~ $CONVENTIONAL;
        push @out, "commit subject: over 72 characters"
            if length($subject) > 72;
        push @out, "commit subject: drop the trailing period"
            if $subject =~ /\.\s*$/;
    }
    return @out;
}

sub check_bash {
    my ($cmd) = @_;
    return () unless defined $cmd && !ref $cmd;
    return () unless $cmd =~ /\bgit\b[^|;&]*?\bcommit\b/;

    my @out;
    push @out, "git commit: $1 trailer is banned; leave the trailer block alone"
        if $cmd =~ $TRAILER;

    my $msg;
    if ($cmd =~ /(?:^|\s)(?:-m|--message[= ])\s*"((?:[^"\\]|\\.)*)"/) { $msg = $1 }
    elsif ($cmd =~ /(?:^|\s)(?:-m|--message[= ])\s*'([^']*)'/)        { $msg = $1 }

    # A message built from a shell variable or command substitution cannot be
    # inspected here, so leave it to the rule file.
    if (defined $msg && $msg !~ /[\$`]/) {
        my ($subject) = split /\\n|\n/, $msg, 2;
        if (defined $subject && length $subject) {
            push @out, "git commit: subject needs a conventional-commit prefix, e.g. 'fix: $subject'"
                unless $subject =~ $CONVENTIONAL;
            push @out, "git commit: subject is over 72 characters"
                if length($subject) > 72;
            push @out, "git commit: drop the trailing period from the subject"
                if $subject =~ /\.\s*$/;
        }
        push @out, "git commit: emoji '$1'" if $msg =~ /($EMOJI)/;
        push @out, "git commit: $_" for ste_scan($msg);
    }
    return @out;
}
