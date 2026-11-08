# Contributing to Eventra

Thanks for contributing. We are a small student team, so keep changes focused and easy to review.

## 1. Work allocation

Only contributors actively implementing code should be assigned coding tasks. Other team members can contribute through:
- User interviews and feedback
- Competitor and usability research
- Figma wireframes and prototypes
- Test cases and usability testing
- Event sample data and documentation

## 2. Branching

Never work directly on `main`.

Create a branch for each task:

```bash
git switch main
git pull
git switch -c feature/event-search
```

Branch naming:
- `feature/short-description`
- `fix/short-description`
- `ui/short-description`
- `docs/short-description`
- `test/short-description`

## 3. Commit messages

Use short, descriptive messages:

```text
feat: add event category filters
fix: prevent booking with zero tickets
ui: improve event card spacing
docs: document attendee booking flow
test: add booking validation tests
```

## 4. Pull request workflow

1. Push your branch.
2. Open a pull request into `main`.
3. Explain what changed and how it was tested.
4. Attach screenshots or a short recording for UI changes.
5. Ask the other active developer to review when possible.
6. Resolve feedback and merge only when the change works.

Keep pull requests small. Avoid combining unrelated screens or features in one PR.

## 5. Before pushing

Run:

```bash
dart format .
flutter analyze
flutter test
```

Fix errors introduced by your changes.

## 6. Code organisation

- Keep screens focused on presentation and user interaction.
- Put reusable widgets in `lib/widgets/`.
- Put data models in `lib/models/`.
- Put repositories and data access in `lib/data/`.
- Keep sample/mock data separate from UI widgets.
- Avoid putting the entire application in `main.dart`.

## 7. Secrets

Never commit Supabase service-role keys, passwords, private tokens, signing keys, or real user data. Use local environment configuration and provide safe setup instructions instead.
