# Important Notes
---

All scripts should be moved to the postgres home directory and ran as the postgres user to avoid errors (which the `./setup.sh` should do)
Password used: `postgres`

# Importing the Database
---

The files `roles.sql` and `HealthcareDB.sql` are the two dump files for the database.
Make sure to import `roles.sql` before `Healthcare.sql` to avoid any errors, which running `./setup.sh` should do

# Testing Script
---

After importing the database, the testing script should be run as the postgres user and from the postgres home directory (in `/var/lib/postgresql` for me)
The script will run through a few SQL queries, showcasing the functions, views, and row-level security used in the database.
