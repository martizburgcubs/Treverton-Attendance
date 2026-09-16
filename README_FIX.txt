TREVERTON COLLEGE — WORKING INTERACTION FIX

The reason the page displayed but none of the controls worked was a JavaScript configuration mismatch:
- config.js defined GHS_SUPABASE_URL / GHS_SUPABASE_ANON_KEY
- app.js was trying to read Treverton_SUPABASE_URL / Treverton_SUPABASE_ANON_KEY

That caused the JavaScript to stop before sports, teams and the register were rendered.

This version fixes that and is also safer:
- The whole register works immediately in DEMO MODE even before Supabase is connected.
- Demo data saves in the browser using localStorage.
- When Treverton Supabase details are added, the same app automatically uses the live database.

FOR NOW:
Replace these in GitHub:
- app.js
- config.js
- index.html
- styles.css
- treverton-logo.png

Then hard refresh with Ctrl+F5.

When ready for live shared data, send the Treverton Supabase Project URL and publishable key.
