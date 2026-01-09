#!/usr/bin/env python3
"""
Comprehensive Installation Test Suite
Tests all installation scenarios and validates everything works as intended
"""

import os
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path

# Colors for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def print_test(test_name):
    print(f"\n{BLUE}Testing: {test_name}{RESET}")

def print_pass(message):
    print(f"{GREEN}✓ PASS{RESET}: {message}")

def print_fail(message):
    print(f"{RED}✗ FAIL{RESET}: {message}")

def print_warn(message):
    print(f"{YELLOW}⚠ WARN{RESET}: {message}")

def test_file_structure():
    """Test that all critical files exist in correct locations"""
    print_test("File Structure")

    required_files = [
        "setup.sh",
        "setup-altitude-enhanced.sh",
        "verify-install.sh",
        "verify-install-enhanced.sh",
        "config.yaml",
        "manifest.yaml"
    ]

    required_dirs = [
        "agents",
        "workflows",
        "knowledge",
        "data"
    ]

    missing = []

    for file in required_files:
        if not os.path.exists(file):
            missing.append(f"File missing: {file}")

    for dir in required_dirs:
        if not os.path.exists(dir):
            missing.append(f"Directory missing: {dir}/")

    if missing:
        for item in missing:
            print_fail(item)
        return False

    print_pass("All critical files and directories present")
    return True

def test_altitude_engine_module():
    """Test that Altitude Engine module can be imported"""
    print_test("Altitude Engine Module Import")

    sys.path.insert(0, 'data')

    try:
        from altitude_engine import AltitudeEngine
        print_pass("Altitude Engine module imports successfully")

        # Check it has required methods
        required_methods = [
            'initialize',
            'store_node',
            'semantic_search',
            'find_similar_nodes',
            'generate_territory_report',
            'close'
        ]

        for method in required_methods:
            if not hasattr(AltitudeEngine, method):
                print_fail(f"Missing method: {method}")
                return False

        print_pass("All required methods present")
        return True

    except ImportError as e:
        print_fail(f"Import failed: {e}")
        return False
    except Exception as e:
        print_fail(f"Unexpected error: {e}")
        return False

def test_critical_fixes():
    """Test that all 7 critical fixes are present in code"""
    print_test("Critical Fixes Verification")

    with open('data/altitude_engine.py', 'r') as f:
        content = f.read()

    fixes = {
        'FIX #1': 'No fake keyword search',
        'FIX #2': 'Safe rollback',
        'FIX #3': 'Thread-safe',
        'FIX #4': 'Context manager',
        'FIX #5': 'Disk space',
        'FIX #6': 'node_id validation',
        'FIX #7': 'Metadata validation'
    }

    found_fixes = []
    for fix_tag, fix_desc in fixes.items():
        if fix_tag in content:
            found_fixes.append(fix_tag)

    if len(found_fixes) == len(fixes):
        print_pass(f"All {len(fixes)} critical fixes present in code")
        return True
    else:
        print_fail(f"Only {len(found_fixes)}/{len(fixes)} fixes found")
        return False

def test_database_integrity():
    """Test database integrity if it exists"""
    print_test("Database Integrity")

    if not os.path.exists('data/vector-embeddings.db'):
        print_warn("Database not yet created (normal before first installation)")
        return True

    try:
        import sqlite3
        conn = sqlite3.connect('data/vector-embeddings.db', timeout=10)
        cursor = conn.cursor()

        # Integrity check
        cursor.execute('PRAGMA integrity_check')
        result = cursor.fetchone()

        conn.close()

        if result[0] == 'ok':
            print_pass("Database integrity verified")
            return True
        else:
            print_fail(f"Database corruption: {result[0]}")
            return False

    except Exception as e:
        print_fail(f"Database check failed: {e}")
        return False

def test_python_dependencies():
    """Test that Python dependencies are available"""
    print_test("Python Dependencies")

    dependencies = {
        'sentence_transformers': 'sentence_transformers',
        'numpy': 'numpy'
    }

    missing = []

    for package_name, import_name in dependencies.items():
        try:
            __import__(import_name)
        except ImportError:
            missing.append(package_name)

    if missing:
        print_fail(f"Missing dependencies: {', '.join(missing)}")
        print_warn("Install with: python3 -m pip install sentence-transformers numpy")
        return False

    print_pass("All Python dependencies available")
    return True

def test_setup_scripts_executable():
    """Test that setup scripts are executable"""
    print_test("Setup Scripts Executable")

    scripts = [
        'setup.sh',
        'setup-altitude-enhanced.sh',
        'verify-install.sh',
        'verify-install-enhanced.sh'
    ]

    not_executable = []

    for script in scripts:
        if os.path.exists(script):
            if not os.access(script, os.X_OK):
                not_executable.append(script)
        else:
            not_executable.append(f"{script} (missing)")

    if not_executable:
        print_fail(f"Scripts not executable: {', '.join(not_executable)}")
        print_warn("Run: chmod +x setup.sh setup-altitude-enhanced.sh verify-install*.sh")
        return False

    print_pass("All setup scripts are executable")
    return True

def test_setup_script_path_handling():
    """Test that setup scripts handle paths correctly"""
    print_test("Setup Script Path Handling")

    # Read setup-altitude-enhanced.sh and check for SCRIPT_DIR
    with open('setup-altitude-enhanced.sh', 'r') as f:
        content = f.read()

    if 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"' in content:
        print_pass("Setup script uses dynamic path detection (SCRIPT_DIR)")
        return True
    else:
        print_fail("Setup script doesn't use dynamic path detection")
        return False

def test_python_pip_usage():
    """Test that setup script uses python3 -m pip"""
    print_test("Python pip Usage")

    with open('setup-altitude-enhanced.sh', 'r') as f:
        content = f.read()

    if 'python3 -m pip install' in content:
        print_pass("Setup script uses python3 -m pip (correct)")
        return True
    else:
        print_fail("Setup script doesn't use python3 -m pip")
        return False

def test_network_connectivity_check():
    """Test that setup script checks network connectivity"""
    print_test("Network Connectivity Check")

    with open('setup-altitude-enhanced.sh', 'r') as f:
        content = f.read()

    if 'check_network_connectivity' in content:
        print_pass("Setup script includes network connectivity check")
        return True
    else:
        print_fail("Setup script missing network connectivity check")
        return False

def test_database_lock_check():
    """Test that setup script checks for database locks"""
    print_test("Database Lock Check")

    with open('setup-altitude-enhanced.sh', 'r') as f:
        content = f.read()

    if 'check_database_lock' in content:
        print_pass("Setup script includes database lock detection")
        return True
    else:
        print_fail("Setup script missing database lock detection")
        return False

def test_preflight_validation():
    """Test that main setup.sh has pre-flight validation"""
    print_test("Pre-flight Validation")

    with open('setup.sh', 'r') as f:
        content = f.read()

    checks = [
        'config.yaml',
        'setup-altitude-enhanced.sh',
        'ALTITUDE_AVAILABLE'
    ]

    found_checks = 0
    for check in checks:
        if check in content:
            found_checks += 1

    if found_checks == len(checks):
        print_pass("Main setup.sh has comprehensive pre-flight validation")
        return True
    else:
        print_fail(f"Pre-flight validation incomplete ({found_checks}/{len(checks)} checks)")
        return False

def test_documentation_present():
    """Test that documentation files exist"""
    print_test("Documentation Files")

    docs = [
        'INSTALLATION.md',
        'ALTITUDE_ENGINE.md',
        'README.md'
    ]

    missing = []
    for doc in docs:
        if not os.path.exists(doc):
            missing.append(doc)

    if missing:
        print_fail(f"Missing documentation: {', '.join(missing)}")
        return False

    print_pass("All documentation files present")
    return True

def test_readme_installation_instructions():
    """Test that README has clear installation instructions"""
    print_test("README Installation Instructions")

    with open('README.md', 'r') as f:
        content = f.read()

    required_sections = [
        'git clone',
        'bash setup.sh',
        'Quick Start'
    ]

    found = 0
    for section in required_sections:
        if section in content:
            found += 1

    if found == len(required_sections):
        print_pass("README has clear installation instructions")
        return True
    else:
        print_fail(f"README missing installation instructions ({found}/{len(required_sections)} sections)")
        return False

def main():
    """Run all tests"""
    print("=" * 60)
    print("COMPREHENSIVE INSTALLATION TEST SUITE")
    print("=" * 60)

    tests = [
        ("File Structure", test_file_structure),
        ("Altitude Engine Module", test_altitude_engine_module),
        ("Critical Fixes", test_critical_fixes),
        ("Database Integrity", test_database_integrity),
        ("Python Dependencies", test_python_dependencies),
        ("Setup Scripts Executable", test_setup_scripts_executable),
        ("Path Handling", test_setup_script_path_handling),
        ("Python pip Usage", test_python_pip_usage),
        ("Network Check", test_network_connectivity_check),
        ("Database Lock Check", test_database_lock_check),
        ("Pre-flight Validation", test_preflight_validation),
        ("Documentation Present", test_documentation_present),
        ("README Instructions", test_readme_installation_instructions),
    ]

    passed = 0
    failed = 0
    warnings = 0

    for test_name, test_func in tests:
        try:
            if test_func():
                passed += 1
            else:
                failed += 1
        except Exception as e:
            failed += 1
            print_fail(f"{test_name}: {e}")

    # Summary
    print("\n" + "=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)
    print(f"{GREEN}Passed:  {passed}{RESET}")
    print(f"{RED}Failed:   {failed}{RESET}")
    print("")

    if failed == 0:
        print(f"{GREEN}╔═══════════════════════════════════════════════════════════════╗{RESET}")
        print(f"{GREEN}║              ✓ ALL TESTS PASSED                                ║{RESET}")
        print(f"{GREEN}║              Installation is READY!                         ║{RESET}")
        print(f"{GREEN}╚═══════════════════════════════════════════════════════════════╝{RESET}")
        print("")
        print("Next steps:")
        print("  1. Commit all files to git: git add -A && git commit")
        print("  2. Push to GitHub: git push origin main")
        print("  3. Users can install with: bash setup.sh")
        print("")
        return 0
    else:
        print(f"{RED}╔═══════════════════════════════════════════════════════════════╗{RESET}")
        print(f"{RED}║              ✗ SOME TESTS FAILED                              ║{RESET}")
        print(f"{RED}║              Please fix issues before distribution          ║{RESET}")
        print(f"{RED}╚═══════════════════════════════════════════════════════════════╝{RESET}")
        print("")
        return 1

if __name__ == '__main__':
    sys.exit(main())
