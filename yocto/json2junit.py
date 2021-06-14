#! /usr/bin/env python3
#
# Copyright (C) 2019 Luxoft Sweden AB
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR
# BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES
# OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
# SOFTWARE.
#
# For further information see LICENSE
#
#
# Usage: json2junit.py <testresults.json>
#
# Converts the given `testresults.json` file, containing the test report
# generated by Yocto `thud` and later, into a set of XML files providing the
# same information in jUnit format.


import argparse
import json
from xml.dom.minidom import getDOMImplementation

parser = argparse.ArgumentParser()
parser.add_argument('file', metavar='FILE', type=str,
        help='Path to Yocto test report (JSON format)')

args = parser.parse_args()

class TestSuite:
    def __init__(self, name, start_time):
        self.name = name
        self.cases = {}
        self.errors = 0
        self.failures = 0
        self.skipped = 0
        self.start_time = start_time
        if len(start_time) >= 14:
            self.iso_time = '{0}-{1}-{2}T{3}:{4}:{5}'.format(
                    start_time[0:4], start_time[4:6], start_time[6:8],
                    start_time[8:10], start_time[10:12], start_time[12:14])
        else:
            self.iso_time = None

    def add_case(self, name, result):
        self.cases[name] = result
        status = result['status']
        if status == 'FAILED':
            self.failures += 1
        elif status == 'ERROR':
            self.errors += 1
        elif status == 'SKIPPED':
            self.skipped += 1

    def copy_text(self, result, input_key, testcase_node, output_key):
        node = self.doc.createElement(output_key)
        if input_key in result:
            text = self.doc.createTextNode(result[input_key])
            node.appendChild(text)
        testcase_node.appendChild(node)

    def case_to_xml(self, testcase_name, result):
        tc = self.doc.createElement('testcase')
        tc.setAttribute('classname', self.name)
        tc.setAttribute('name', testcase_name)
        if self.iso_time:
            tc.setAttribute('timestamp', self.iso_time)
        if 'duration' in result:
            tc.setAttribute('time', str(result['duration']))
        status = result['status']
        if status == 'FAILED':
            extra = self.doc.createElement('failure')
            extra.setAttribute('type', 'AssertionError')
            msg = self.doc.createTextNode(result['log'])
            extra.appendChild(msg)
        elif status == 'ERROR':
            extra = self.doc.createElement('error')
            msg = self.doc.createTextNode(result['log'])
            extra.appendChild(msg)
        elif status == 'SKIPPED':
            extra = self.doc.createElement('skipped')
            extra.setAttribute('type', 'skip')
            extra.setAttribute('message', result['log'])
        else:
            extra = None
        if extra:
            tc.appendChild(extra)
        self.copy_text(result, 'stdout', tc, 'system-out')
        self.copy_text(result, 'stderr', tc, 'system-err')
        return tc

    def to_xml(self):
        impl = getDOMImplementation()
        self.doc = impl.createDocument(None, "testsuite", None)
        ts = self.doc.documentElement
        ts.setAttribute('name', '{0}-{1}'.format(self.name, self.start_time))
        ts.setAttribute('tests', str(len(self.cases)))
        ts.setAttribute('errors', str(self.errors))
        ts.setAttribute('failures', str(self.failures))
        ts.setAttribute('skipped', str(self.skipped))
        if self.iso_time:
            ts.setAttribute('timestamp', self.iso_time)

        for testcase_name, result in self.cases.items():
            tc = self.case_to_xml(testcase_name, result)
            ts.appendChild(tc)

        filename = 'TEST-{0}-{1}.xml'.format(self.name, self.start_time)
        with open(filename, 'w') as out:
            self.doc.writexml(out, addindent='  ', newl='\n')


with open(args.file, 'r') as f:
    data = json.load(f)
    for name, testdata in data.items():
        results = testdata['result']
        suites = {}

        start_time = testdata['configuration']['STARTTIME']

        for test_name, result in results.items():
            parts = test_name.split('.')
            assert len(parts) == 3

            suite_name = '.'.join(parts[0:2])
            testcase_name = f"{suite_name}_{start_time}"

            if suite_name not in suites:
                suites[suite_name] = TestSuite(suite_name, start_time)
            suite = suites[suite_name]
            suite.add_case(testcase_name, result)

        for suite in suites.values():
            suite.to_xml()
