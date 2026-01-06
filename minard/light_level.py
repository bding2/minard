from .db import engine_nl
from sqlalchemy import text

def get_light_level(run_begin, run_end, fv_cut):
    '''
    Get the light levels from the 210Po peak location
    '''
    conn = engine_nl.connect()

    result = conn.execute(text("SELECT DISTINCT ON(run) run::INTEGER, peak "
                          "FROM po210_nhits WHERE run >= :run_begin AND run <= :run_end "
                          "AND fv_cut = :fv_cut AND peak > 0 ORDER BY run, timestamp DESC"), {'run_begin': run_begin, 'run_end': run_end, 'fv_cut': fv_cut})

    keys = list(map(str, result.keys()))
    rows = result.fetchall()

    return [dict(zip(keys,row)) for row in rows]


def get_light_level_clean(run_begin, run_end, fv_cut):
    '''
    Get the light levels from the 210Po peak location
    '''
    conn = engine_nl.connect()

    result = conn.execute(text("SELECT DISTINCT ON(run) run::INTEGER, peak_clean "
                          "FROM po210_nhits WHERE run >= :run_begin AND run <= :run_end "
                          "AND fv_cut = :fv_cut AND peak_clean > 0 ORDER BY run, timestamp DESC"), {'run_begin': run_begin, 'run_end': run_end, 'fv_cut': fv_cut})

    keys = list(map(str, result.keys()))
    rows = result.fetchall()

    return [dict(zip(keys,row)) for row in rows]

def get_all_light_levels(run_begin, run_end, fv_cut, limit):
    '''
    Get the light levels from the 210Po peak location
    '''
    conn = engine_nl.connect()

    result = conn.execute(text("SELECT DISTINCT ON(run) run::INTEGER, peak, peak_clean, "
                          "peak_unc, peak_clean_unc, fv_cut, entries "
                          "FROM po210_nhits WHERE run >= :run_begin AND run <= :run_end "
                          "AND fv_cut = :fv_cut ORDER BY run DESC, timestamp DESC LIMIT :limit"), {'run_begin': run_begin, 'run_end': run_end, 'fv_cut': fv_cut, 'limit': limit})

    keys = list(map(str, result.keys()))
    rows = result.fetchall()

    return [dict(zip(keys,row)) for row in rows]

