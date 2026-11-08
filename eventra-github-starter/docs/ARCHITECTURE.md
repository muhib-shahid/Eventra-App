# Eventra — Architecture Plan

## Initial structure

Keep the first increment simple. Suggested Flutter structure as the app grows:

```text
lib/
  main.dart
  app/
    app.dart
    theme/
      app_theme.dart
      app_colors.dart
  models/
    event.dart
    booking.dart
    user_profile.dart
  data/
    mock/
      sample_events.dart
    repositories/
      event_repository.dart
      booking_repository.dart
  features/
    home/
      home_screen.dart
    explore/
      explore_screen.dart
    event_details/
      event_details_screen.dart
    bookings/
      bookings_screen.dart
    favourites/
      favourites_screen.dart
    profile/
      profile_screen.dart
    organizer/
      organizer_dashboard_screen.dart
  widgets/
    event_card.dart
    category_chip.dart
    primary_button.dart
```

This is a target structure, not a requirement to create every file immediately. Add folders when the corresponding feature is implemented.

## Data entities

### Event
- id
- title
- description
- category
- startDateTime
- endDateTime
- venueName
- address
- price
- availableTickets
- coverImageUrl
- organizerId
- status

### Booking
- id
- eventId
- attendeeId
- ticketQuantity
- totalPrice
- bookingReference
- bookingStatus
- createdAt

### User profile
- id
- displayName
- email
- role (attendee or organizer)
- profileImageUrl

## Data strategy

**Increment 1:** Use local mock data. The app must remain usable without an internet connection.

**Later:** Add Supabase behind repository interfaces so UI screens do not directly contain database queries.

## Important implementation rule

Do not mix mock data, Supabase calls, navigation, and complex UI code in one widget. Keep responsibilities separate as the project grows.
