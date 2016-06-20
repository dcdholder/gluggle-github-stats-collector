Functionality
=============

Will spit out per-project contribution statistics for the project owner (added lines, deleted lines, the difference thereof) and a total for each statistic over all owned repos.

"Installation"
==============

1. Clone the repo.
2. Install ruby with 'apt-get install ruby-dev' if necessary.
3. Install the json gem with 'gem install json'.
4. Run with 'ruby <filename>.rb'

Known Defects
=============

- Occasionally fails to find statistics for a project - need to add a retry mechanism or something instead of just ignoring missed projects
