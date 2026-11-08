# Eventra

A mobile-first event discovery and ticket booking application developed as a Human–Computer Interaction (HCI) semester project.

## Project goals

Eventra helps people discover events, understand event details, save events, and complete a simple booking journey. The project prioritises usability, accessibility, clear feedback, and consistent interaction design.

## Planned user roles

- **Attendee:** discovers events, searches and filters listings, views event details, saves favourites, and manages bookings.
- **Organizer:** creates and manages event listings and reviews bookings.

## Initial technology choices

- Flutter / Dart — Android-first mobile application
- Supabase — authentication, PostgreSQL database, and image storage (introduced after the local prototype)
- Figma — wireframes, prototypes, and design system
- GitHub — source control, issues, pull requests, and project documentation

## Development principles

1. Build in small, working increments.
2. Keep `main` stable; work on feature branches.
3. Open pull requests instead of pushing directly to `main`.
4. Keep UI, data models, and data access separated.
5. Never commit passwords, API keys, signing keys, or `.env` files.
6. Test important user journeys on an actual Android device or emulator.
7. Make HCI decisions explicit and validate them with users.

## Planned increments

### Milestone 1 — Working prototype
- Flutter project setup
- App theme and reusable components
- Bottom navigation
- Home, Explore, Event Details, Bookings, and Profile screens
- Local sample event data
- Search and basic category filters

### Milestone 2 — Booking journey
- Event details and ticket options
- Booking confirmation
- My Bookings / ticket history
- Favourites

### Milestone 3 — Persistence and accounts
- Supabase setup
- Registration and login
- Persistent favourites and bookings
- User profile

### Milestone 4 — Organizer workflows
- Create, edit, publish, and delete events
- Upload event cover images
- View bookings for an event

### Milestone 5 — HCI refinement
- Empty, loading, success, and error states
- Accessibility review
- Usability testing and iteration
- Final polish and documentation

## Getting started

Install Flutter and Android Studio, then verify the environment:

```bash
flutter doctor
```

Create the Flutter application:

```bash
flutter create eventra
cd eventra
flutter run
```

Copy the project documentation and `.github` folder from this starter pack into the generated `eventra` folder. Then initialise Git:

```bash
git init
git add .
git commit -m "chore: initialize Eventra project"
```

Create an empty GitHub repository named `eventra` (do not initialise it with a README if you already have this local commit), then connect and push:

```bash
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/eventra.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username.

## Team workflow

See [CONTRIBUTING.md](CONTRIBUTING.md) for branches, commits, pull requests, and review rules.

## HCI documentation

- [Product scope](docs/PRODUCT_SCOPE.md)
- [Architecture plan](docs/ARCHITECTURE.md)
- [HCI plan](docs/HCI_PLAN.md)

## Images and assets

Use images that are licensed for reuse or created by the team. Keep image assets compressed and appropriately sized. Add attribution in `assets/ATTRIBUTIONS.md` whenever required by the image licence. Do not commit images copied from event organisers or photographers without permission.

## Project status

Early development — scope and implementation may evolve after initial user feedback.
