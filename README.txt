TREVERTON COLLEGE SPORTS REGISTER — ONLINE PACKAGE

Theme
- Treverton badge included
- Navy / orange / white colour scheme based on the school badge
- Motto styling kept subtle and professional

System included
- Multi-sport register
- Editable player names
- Attendance by session
- Individual Practice Attendance %
- Team Practice Attendance %
- Player coaching/development notes
- Coach injury/physical concern workflow
- Automatic S&C review queue
- S&C decides Injured / No Play, Low Intensity, or Cleared
- Bus register
- One saved record per vehicle journey
- Passenger lookup
- Transport history
- Remove / recover transport records
- Mobile-friendly layout
- Print register

Attendance percentage
Present ÷ marked Monday/Tuesday practices × 100
Wednesday match days are excluded.
Unmarked (?) sessions are excluded.

FILES
index.html
styles.css
app.js
config.js
treverton-logo.png
01_TREVERTON_DATABASE_SETUP.sql

ONLINE SETUP
1. Create or choose a Supabase project for Treverton.
2. Run 01_TREVERTON_DATABASE_SETUP.sql.
3. Put the Supabase Project URL and publishable key into config.js.
4. Upload index.html, styles.css, app.js, config.js, treverton-logo.png to GitHub.
5. Connect the GitHub repo to Cloudflare Pages.

The Treverton database tables use the prefix:
trev_

This keeps them separate from the SJS and Girls' High tables.
