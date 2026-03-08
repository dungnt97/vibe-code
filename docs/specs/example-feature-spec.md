# Example Feature Spec: User Authentication System

> This is an example of what a supplementary spec document looks like.
> For formal OpenSpec-managed specs, use `/opsx:propose`.
> This format is for lighter documentation needs.

## Overview

Add email/password authentication with JWT tokens and refresh token rotation.

## Requirements

1. Users can register with email + password
2. Users can log in and receive JWT access token (15 min) + refresh token (7 days)
3. Refresh tokens rotate on use (old token invalidated)
4. Passwords hashed with bcrypt (cost 12)
5. Rate limiting: 5 failed login attempts → 15 min lockout

## Technical Approach

- Auth middleware validates JWT on protected routes
- Refresh token stored in httpOnly cookie
- Token blacklist in Redis (for logout/rotation)
- Password reset via email with time-limited token

## Related Beads

- bd-auth01: Set up auth middleware
- bd-auth02: Implement registration endpoint
- bd-auth03: Implement login endpoint
- bd-auth04: Implement refresh token rotation
- bd-auth05: Add rate limiting

## Related Decisions

- 0002-use-jwt-over-sessions.md (hypothetical)
