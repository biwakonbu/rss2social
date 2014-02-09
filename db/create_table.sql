create table rss_entries(
       id       integer not null primary key autoincrement,
       title    text not null,
       url      text not null,
       posted   integer not null default 0 check(posted in (0, 1))
);
