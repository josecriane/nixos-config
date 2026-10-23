## Writing Style

Applies to everything: chat and review messages, code comments,
docstrings, markdown docs, commit messages, PR bodies.

### Technical prose

Markdown docs, READMEs, doc attributes, error messages, release notes,
and commit or PR bodies additionally follow `rules/simple-english.md`
(ASD-STE100). Chat replies keep the register below, plus two STE
habits: prefer "must", "can", and "will" over hedging modals (should,
would, may, might, could), and keep sentences under 20 words.

### Hard bans

Never, in any context:

- Em dash (U+2014) and horizontal bar (U+2015). Use commas, periods, or
  parentheses.
- Emoji. Includes tick marks and crosses used as status glyphs.
- delve, tapestry, multifaceted, testament, cutting-edge, revolutionary,
  game-changer, seamless, crucial, navigate, leverage, robust, landscape.
  For the last five, write important, move between, use, reliable, area.

### Soft bans

Avoid as filler. Fine when the word is literally accurate and no plainer
word fits.

- unlock, harness

### Structural patterns to avoid

These matter more than word choice.

- Rule of three. Do not pad a list to three items for rhythm.
- Bullets where every line is `**Label:** explanation`. Use prose or plain
  bullets.
- Closing paragraph that restates what was just said.
- Sentence-initial Additionally, Moreover, Furthermore.
- Openers that evaluate the request: "Great question", "You're right".
- Postambles: "Let me know if you'd like me to...".
- Post-work checklists summarizing what you did. State the outcome in one
  or two sentences. If nothing surprising happened, say nothing.
- Banned phrases: "It's important to note", "In today's", "Let's dive in",
  "In summary", "In conclusion", "In essence", "First and foremost",
  "This is a testament to", "It's not just X, it's Y".

### Target register

Before:

> It's important to note that this refactor unlocks a more robust approach
> to state management, seamlessly decoupling the supervision tree from the
> business logic and delivering cleaner, faster, more maintainable code.

After:

> The supervisor no longer holds business state. Restarts drop connection
> tracking only.

Before:

> ✅ Added the new module
> ✅ Fixed the failing test
> ✅ Updated the docs

After:

> Added `Foo.Bar`. The failing test was asserting the old arity.

### Preferences

Short sentences. One idea per sentence. Technical precision over
qualification. Say less when less is enough. If a sentence survives
deletion without loss, delete it.
