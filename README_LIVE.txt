TREVERTON COLLEGE — LIVE SUPABASE CONNECTION

Connected Supabase project:
https://ccvcbcpjyhrpbdjboszr.supabase.co

The publishable key is already inserted into config.js.

IMPORTANT:
Treverton uses trev_ database tables, separate from the Girls' High ghs_ tables.

If you have NOT yet run the Treverton database SQL:
1. Open Supabase project ccvcbcpjyhrpbdjboszr.
2. Open SQL Editor.
3. Run 01_TREVERTON_DATABASE_SETUP.sql from this package.

Then upload/replace these files in the Treverton GitHub repo:
- config.js
- app.js
- index.html
- styles.css
- treverton-logo.png

Commit the files and let Cloudflare redeploy.
Then hard refresh with Ctrl+F5.

When the database connection is working, the demo-mode banner disappears automatically.
