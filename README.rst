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


Example
-------

::

  mlstats ~/mail freeipa-users@redhat.com redhat.com 60
