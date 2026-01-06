import os
os.environ['MINARD_SETTINGS'] = '/home/snotdaq/SNOPLUS/minard/settings.conf'

from minard.db import engine_nl
from sqlalchemy import text

try:
    conn = engine_nl.connect()
    
    query = "SELECT meta_data, name, timestamp, run_min FROM run_selection WHERE type = 'RS_REPORT' AND criteria = 'scintillator' ORDER BY run_min DESC LIMIT 50"
    
    result = conn.execute(text(query))
    rows = result.fetchall()
    print(f"Found {len(rows)} rows")
    if rows:
        print(f"First row: {rows[0]}")
    
    conn.close()
except Exception as e:
    import traceback
    print(f"Error: {e}")
    traceback.print_exc()