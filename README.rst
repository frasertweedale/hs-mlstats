``mlstats`` extracts mailing list statistics from a notmuch
database.

Usage
-----

::

  mlstats <notmuch-dir> <list-addr> <exclude-domain> <days>

``notmuch-dir``
  Directory containing the notmuch database where the list mail is
  indexed.

``list-addr``
  Mailing list address.

``exclude-domain``
  A column of statistics that *exclude* this domain will be
  generated.  Useful for seeing how much mail *did not come*
  from a particular domain.

``days``
  Number of days of statistics to print, up to the current day.


Example (with output)
---------------------

::

  % mlstats ~/mail freeipa-users@redhat.com redhat.com 10
  2015-04-28 29 11 13
  2015-04-29 37 1 9
  2015-04-30 43 13 9
  2015-05-01 11 1 3
  2015-05-02 10 8 6
  2015-05-03 4 2 3
  2015-05-04 20 11 10
  2015-05-05 27 19 10
  2015-05-06 44 18 13
  2015-05-07 34 11 11
  2015-05-08 15 3 6

The output columns, from left to right, are:

0. Date (UTC)
1. Message count
2. Message count excluding message from ``exclude-domain``
3. Active thread count
