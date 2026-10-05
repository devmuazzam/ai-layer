# Weather is out of scope for the project

**Date:** 2026-10-05
**Decider:** Product Owner (User)
**Ticket:** TCG-63

## Decision

The weather feature (displaying current weather conditions, weather alerts, or pulling weather data for crane tickets) is explicitly out of scope for the project. 

## Context

The initial Atom user stories and June UI prototypes promised weather information and "weather alerts" on the mobile application for crane tickets, given that high wind is a safety stop-work condition. However, there were no functional requirements (FRDs) for a weather feature. The mobile app contained hardcoded "fake" mock data that was unconditionally injected, which posed a safety risk if rendered, because a crew might mistake it for a live observation.

When queried about whether this feature should be actually built (which would require a paid weather API integration, backend storage, etc.), the product owner confirmed that the feature is out of scope. 

## Impact

- All hardcoded fake weather sample data has been completely removed from the mobile application (contracts, models, fixtures).
- The "weather alerts" marketing copy in the app onboarding screen has been removed.
- Fake weather notifications from the mock service have been removed.
- We will not integrate any external weather API or provide weather readings on the digital ticket. Crews will rely on their standard physical observation procedures for wind and weather conditions.
