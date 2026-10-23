## Simple English (ASD-STE100)

Controlled-language rules derived from ASD-STE100 Simplified Technical
English (Issue 9). Apply them to technical prose: markdown docs, READMEs,
runbooks, doc attributes,
error and log messages, release notes, commit bodies, PR bodies.

Do not apply them to: chat replies (`writing-style.md` governs those,
with the subset noted there), code itself, quoted text, marketing or
brand copy.

### Classify first

Procedural text tells the reader what to do. Imperative mood, maximum
20 words per sentence, one instruction per sentence.

Descriptive text explains. Simple tenses, maximum 25 words per sentence,
one topic per paragraph, maximum six sentences per paragraph.

Do not mix the two in one passage.

### Verbs

- Allowed forms: infinitive, imperative, simple present, simple past,
  simple future, past participle as adjective.
- No perfect tenses. "has completed" becomes "completed". "had been
  removed" becomes "was removed".
- No "-ing" verb forms. ", making the build fast" becomes a new
  sentence: "This makes the build fast."
- Active voice. Passive is allowed only in descriptive text when the
  agent is unknown or irrelevant.
- Modals: only `can`, `will`, `must`. Banned: should, would, may,
  might, could. For "should": write "must" when it is a requirement,
  delete it when it is a recommendation.

### Sentences

- No contractions. Keep articles. Keep "that": "make sure that the
  file exists".
- Condition before command, with a comma: "If the test fails, read
  the log."
- No semicolons. Write two sentences.
- Use a vertical list for more than two items or steps.

### Words

- One word, one meaning, for the whole document. Pick one of check,
  verify, confirm and keep it. Same for option, setting, parameter.
- Noun chains of maximum three words. Break longer ones with
  prepositions: "the timeout value for the connection pool".
- Replace "utilize" with "use", "prior to" with "before", "in the
  event that" with "if", "in order to" with "to", "e.g." with "for
  example", "i.e." with "that is".
- Delete words that carry no fact. `writing-style.md` lists the bans.
- American spelling.

### Warnings

Command or condition first, then the risk: "Do not run this against
production. The command deletes rows."

### Never touch

Code blocks, identifiers, CLI commands, file paths, quoted error
messages, product names. Each counts as one word toward the sentence
limits.

### Self-check

Before returning technical prose, scan for contractions, "has been",
"should", ", making", and semicolons. Count the words in the three
longest sentences and split any over the limit. Collapse synonym
rotation to the chosen term.
