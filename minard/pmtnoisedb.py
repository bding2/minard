from .db import engine_nl
from datetime import datetime
from .tools import total_seconds
from sqlalchemy import text

SECOND_PER_DAY = 24*60*60
SECOND_PER_MICROSECOND = 1e-6

# turn a sql result into a list of dicts
def dictify(result):
    keys = result.keys()
    rv = []
    for row in result:
        d = dict(zip(keys, row))
        rv.append(d)
    return rv

def get_noise_results(limit=100, offset=0):
    epoch = datetime(1970, 1, 1)
    conn = engine_nl.connect()
    rows = conn.execute(text('SELECT * FROM pmtnoise '
                        'ORDER BY run_number DESC '
                        'LIMIT :limit OFFSET :offset;'), {'limit': limit, 'offset': offset})
    rows = dictify(rows)
    for row in rows:
        row['display_time'] = str(row['timestamp'])[:-6]
        delta = (row['timestamp'].replace(tzinfo=None) - row['timestamp'].utcoffset() - epoch)
        row['plot_time'] = total_seconds(delta)
    return rows

def get_run_by_number(run):
    conn = engine_nl.connect()
    rows = conn.execute(text('SELECT * FROM pmtnoise WHERE run_number = :run;'), \
                        {'run': int(run)})
    return dictify(rows)
