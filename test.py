#!/usr/bin/env python3
import os
import sys
import json
import argparse

def find_repo_root(max_up=6):
    p = os.path.abspath(os.path.dirname(__file__))
    for _ in range(max_up):
        if os.path.isdir(os.path.join(p, 'minard')):
            return p
        p = os.path.dirname(p)
    return None

def main():
    parser = argparse.ArgumentParser(description='Call get_list_history(run) from minard.RSTools')
    parser.add_argument('run', type=int, help='Run number (int)')
    args = parser.parse_args()

    repo_root = find_repo_root()
    if repo_root is None:
        print('ERROR: could not find repository root containing "minard" package', file=sys.stderr)
        sys.exit(2)
    if repo_root not in sys.path:
        sys.path.insert(0, repo_root)

    try:
        from minard.RSTools import get_list_history
    except Exception as e:
        print('ERROR importing get_list_history:', e, file=sys.stderr)
        sys.exit(3)

    try:
        data = get_list_history(args.run)
    except Exception as e:
        print('ERROR calling get_list_history:', e, file=sys.stderr)
        sys.exit(4)

    if data is False:
        print('null')
        return

    print(json.dumps(data, indent=2, default=str))

if __name__ == '__main__':
    main()